xml = Builder::XmlMarkup.new
xml.instruct!
si_by_brand = SaleItem.find(@chosen_sale_item)
@nobukti = Time.now.strftime("%d%m%Y%H%M%S")
xml.data do
  si_by_brand.each do |si|
    si.update_attributes!(no_bukti_exported: @nobukti)
    xml.pbjshow do
      xml.ExSJ si.ex_no_sj.blank? ? '-' : si.ex_no_sj
      xml.kodebrg si.kode_barang
      xml.namabrg si.nama_barang
      xml.qty si.jumlah
      xml.status 1
      xml.satuan "PCS"
      xml.created si.created_at.strftime('%m/%d/%Y')
      xml.createdby SalesPromotion.find(si.sale.sales_promotion_id).nama.capitalize
      xml.bonus si.bonus? ? 'BONUS' : '-'
      xml.noso si.sale.no_so
      xml.KeteranganSO si.sale.keterangan_customer
      xml.NoPo si.sale.no_so
      xml.keterangan si.keterangan.blank? ? "-"  : si.keterangan
      xml.TglDelivery si.tanggal_kirim.strftime("%m/%d/%Y")
      xml.AlamatKirim si.sale.pos_ultimate_customer.alamat+" "+ si.sale.pos_ultimate_customer.kota.capitalize
      xml.Customer si.sale.pos_ultimate_customer.nama
      xml.Alamat1 si.sale.pos_ultimate_customer.alamat
      if si.brand_id == 2 || si.brand_id == 6
        xml.KodePameran si.sale.channel_customer.kode_showroom
      else
        xml.KodePameran si.sale.channel_customer.kode_channel_customer
      end
      xml.NamaPameran si.sale.channel_customer.nama
      siscc = si.sale.channel_customer
      xml.DariTanggal siscc.dari_tanggal.nil? ? '' : siscc.dari_tanggal.strftime("%m/%d/%Y")
      xml.SampaiTanggal siscc.sampai_tanggal.nil? ? '' : siscc.sampai_tanggal.strftime("%m/%d/%Y")
      xml.AsalSo si.sale.channel_customer.channel.channel
      xml.SPG si.sale.sales_promotion_id.nil? ? @user.channel_customer.nama.titleize :
        si.sale.channel_customer.sales_promotions.find(si.sale.sales_promotion_id).nama.titleize
      xml.Taken (si.taken? ? 'Y' : 'T')
      xml.Serial si.serial.blank? ? '-' : si.serial
      xml.PriceList si.price_list
      xml.Voucher si.sale.voucher
      xml.Phone si.sale.pos_ultimate_customer.no_telepon
      xml.Hp1 si.sale.pos_ultimate_customer.handphone.blank? ? '-' : si.sale.pos_ultimate_customer.handphone
      xml.Hp2 si.sale.pos_ultimate_customer.handphone1.blank? ? '-' : si.sale.pos_ultimate_customer.handphone1
      xml.HargaNetto si.sale.netto
      dp = (si.sale.pembayaran+si.sale.payment_with_debit_cards.sum(:jumlah)+si.sale.payment_with_credit_cards.sum(:jumlah)+si.sale.jumlah_transfer + si.sale.voucher)
      xml.DP dp
      xml.Sisa si.sale.sisa
      xml.TipePembayaran si.sale.tipe_pembayaran
      xml.Tunai si.sale.pembayaran
      xml.no_kartu_debit si.sale.payment_with_debit_cards.first.no_kartu_debit.blank? ? '-' : si.sale.payment_with_debit_cards.first.no_kartu_debit
      xml.nama_kartu_debit si.sale.payment_with_debit_cards.first.nama_kartu.blank? ? '-' : si.sale.payment_with_debit_cards.first.nama_kartu
      xml.atas_nama_debit si.sale.payment_with_debit_cards.first.atas_nama.blank? ? '-' : si.sale.payment_with_debit_cards.first.atas_nama
      xml.JumlahDebit si.sale.payment_with_debit_cards.first.jumlah
      xml.NoMerchant si.sale.payment_with_credit_cards.first.no_merchant.blank? ? '-' : si.sale.payment_with_credit_cards.first.mid
      xml.NoKartu si.sale.payment_with_credit_cards.first.no_kartu_kredit.blank? ? '-' : si.sale.payment_with_credit_cards.first.no_kartu_kredit
      xml.NamaKartu si.sale.payment_with_credit_cards.first.nama_kartu.blank? ? '-' : si.sale.payment_with_credit_cards.first.nama_kartu
      xml.AtasNama si.sale.payment_with_credit_cards.first.atas_nama.blank? ? '-' : si.sale.payment_with_credit_cards.first.atas_nama
      xml.JumlahKredit si.sale.payment_with_credit_cards.first.jumlah
      xml.NoMerchant1 si.sale.payment_with_credit_cards.last.no_merchant.blank? ? '-' : si.sale.payment_with_credit_cards.last.mid
      xml.NoKartu1 si.sale.payment_with_credit_cards.last.no_kartu_kredit.blank? ? '-' : si.sale.payment_with_credit_cards.last.no_kartu_kredit
      xml.NamaKartu1 si.sale.payment_with_credit_cards.last.nama_kartu.blank? ? '-' : si.sale.payment_with_credit_cards.last.nama_kartu
      xml.AtasNama1 si.sale.payment_with_credit_cards.last.atas_nama.blank? ? '-' : si.sale.payment_with_credit_cards.last.atas_nama
      xml.JumlahKredit1 si.sale.payment_with_credit_cards.last.jumlah
      xml.Email si.sale.email
      netto_brand =
        if si.brand_id == 2
        si.sale.netto_elite
      elsif si.brand_id == 4
        si.sale.netto_lady
      elsif si.brand_id == 5
        si.sale.netto_royal
      elsif si.brand_id == 6
        si.sale.netto_serenity
      elsif si.brand_id == 7
        si.sale.netto_tech
      end
      xml.NettoBrand netto_brand
      xml.NamaRekening si.sale.bank_account.nil? ? '' : si.sale.bank_account.name
      xml.NoRekening si.sale.bank_account.nil? ? '' : si.sale.bank_account.account_number
      xml.JumlahTransfer si.sale.jumlah_transfer
      xml.StatusSO si.stocking_type
    end
  end
end
xml_data = xml.target!
set_file_name = @nobukti
file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
file.write(xml_data)
file.close
@sales.group_by(&:brand_id).keys.each do |group|
  emails = []
  @user.recipients.where(brand_id: group).each do |rc|
    emails << rc.sales_counter.email
  end
  UserMailer.order_pameran(emails, "/xml/#{set_file_name}", @user, @sales, @sales.first.stocking_type).deliver_now
end