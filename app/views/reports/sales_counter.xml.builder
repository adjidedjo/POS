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
        xml.KeteranganSO sale_item.sale.keterangan_customer+";"+" "+("Sisa Pembayaran: Rp. "+sisa)
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
    end
  end
end