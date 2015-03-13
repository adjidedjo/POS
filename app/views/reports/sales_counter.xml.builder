xml = Builder::XmlMarkup.new
xml.instruct!
xml.data do
  @sales.each do |sale_item|
    xml.pbjshow do
      xml.kodebrg sale_item.kode_barang
      xml.namabrg sale_item.nama_barang
      xml.qty sale_item.jumlah
      xml.status 1
      xml.satuan "PCS"
      xml.created sale_item.created_at.strftime('%m/%d/%Y')
      xml.createdby SalesPromotion.find(sale_item.sale.sales_promotion_id).nama.capitalize
      xml.bonus sale_item.bonus? ? 'BONUS' : '-'
      xml.noso sale_item.no_so
      xml.keterangan sale_item.sale.keterangan_customer
      xml.NoPo sale_item.sale.no_so
      sisa = sale_item.sale.sisa.to_s
      if sale_item.sale.sisa?
        xml.KeteranganSO sale_item.sale.keterangan_customer+";"+" "+("Sisa Pembayaran: Rp. "+number_to_currency(sisa, precision:0, unit: "Rp. ", separator: ".", delimiter: "."))
      else
        xml.KeteranganSO sale_item.sale.keterangan_customer
      end
      xml.TglDelivery sale_item.tanggal_kirim.strftime("%m/%d/%Y")
      xml.AlamatKirim sale_item.sale.alamat_kirim
      xml.Customer sale_item.sale.customer
      xml.Alamat1 sale_item.sale.alamat_kirim
      xml.KodePameran sale_item.sale.store.kode_customer
      xml.NamaPameran sale_item.sale.store.nama
      xml.DariTanggal sale_item.sale.store.from_period.strftime("%m/%d/%Y")
      xml.SampaiTanggal sale_item.sale.store.to_period.strftime("%m/%d/%Y")
      xml.AsalSo sale_item.sale.store_id.nil? ? 'SHOWROOM' : 'PAMERAN'
      xml.SPG SalesPromotion.find(sale_item.sale.sales_promotion_id).nama.capitalize
      xml.taken sale_item.taken
      item = Item.find_by_kode_barang(sale_item.kode_barang)
      xml.PriceList item.nil? ? '0' : item.harga
      price_list = []
      sale_item.sale.sale_items.each do |sale_item_harga|
        get_price_list = Item.find_by_kode_barang(sale_item_harga.kode_barang)
        price_list << get_price_list.harga unless get_price_list.nil?
      end
      total_price_list = price_list.sum
      diskon = total_price_list - sale_item.sale.pembayaran
      xml.Diskon diskon
      dp = sale_item.sale.pembayaran - (sale_item.sale.netto - sale_item.sale.voucher)
      xml.DP dp
      xml.PPN
    end
  end
end
xml_data = xml.target!
set_file_name = Time.now.strftime("%d%m%Y%H%M%S")
file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
file.write(xml_data)
file.close
UserMailer.order_pameran(@email, "#{set_file_name}").deliver_now