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
      xml.noso sale_item.sale.no_so
      sisa = sale_item.sale.sisa.to_s
      if sale_item.sale.sisa?
        xml.KeteranganSO sale_item.sale.keterangan_customer+";"+" "+("Sisa Pembayaran: Rp. "+number_to_currency(sisa, precision:0, unit: "Rp. ", separator: ".", delimiter: "."))
      else
        xml.KeteranganSO sale_item.sale.keterangan_customer
      end
      xml.NoPo sale_item.sale.no_so
      xml.keterangan
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
      xml.Taken (sale_item.taken? ? 'Y' : 'T')
      xml.Serial sale_item.serial.blank? ? '-' : sale_item.serial
      item = Item.find_by_kode_barang(sale_item.kode_barang)
      xml.PriceList item.nil? ? '0' : item.harga
      xml.Voucher sale_item.sale.voucher
      xml.Phone sale_item.sale.phone_number
      xml.Hp1 sale_item.sale.hp1.blank? ? '-' : sale_item.sale.hp1
      xml.Hp2 sale_item.sale.hp2.blank? ? '-' : sale_item.sale.hp2
      xml.HargaNetto sale_item.sale.netto
      dp = (sale_item.sale.netto - sale_item.sale.voucher) - (sale_item.sale.pembayaran+sale_item.sale.payment_with_debit_card.jumlah+sale_item.sale.payment_with_credit_cards.sum(:jumlah))
      xml.DP dp
      xml.Sisa sale_item.sale.sisa
      xml.TipePembayaran sale_item.sale.tipe_pembayaran
      xml.no_kartu_debit sale_item.sale.payment_with_debit_card.no_kartu.blank? ? '-' : sale_item.sale.payment_with_debit_card.no_kartu
      xml.nama_kartu_debit sale_item.sale.payment_with_debit_card.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_debit_card.nama_kartu
      xml.atas_nama_debit sale_item.sale.payment_with_debit_card.atas_nama.blank? ? '-' : sale_item.sale.payment_with_debit_card.atas_nama
      xml.NoMerchant sale_item.sale.payment_with_credit_cards.first.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.no_merchant
      xml.NoKartu sale_item.sale.payment_with_credit_cards.first.no_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.no_kartu
      xml.NamaKartu sale_item.sale.payment_with_credit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.nama_kartu
      xml.AtasNama sale_item.sale.payment_with_credit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.atas_nama
      xml.NoMerchant1 sale_item.sale.payment_with_credit_cards.last.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.no_merchant
      xml.NoKartu1 sale_item.sale.payment_with_credit_cards.last.no_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.no_kartu
      xml.NamaKartu1 sale_item.sale.payment_with_credit_cards.last.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.nama_kartu
      xml.AtasNama1 sale_item.sale.payment_with_credit_cards.last.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.atas_nama
      xml.Email sale_item.sale.email
      xml.ExSJ sale_item.ex_no_sj.blank? ? '-' : sale_item.ex_no_sj
      netto_brand = sale_item.brand_id == 2 ? sale_item.sale.netto_elite : sale_item.sale.netto_lady
      xml.NettoBrand netto_brand
    end
  end
end
xml_data = xml.target!
set_file_name = Time.now.strftime("%d%m%Y%H%M%S")
file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
file.write(xml_data)
file.close
UserMailer.order_pameran(@email, "#{set_file_name}").deliver_now