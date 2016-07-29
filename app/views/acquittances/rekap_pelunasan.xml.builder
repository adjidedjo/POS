xml = Builder::XmlMarkup.new
xml.instruct!
xml.data do
  @acquittance.each do |acq|
    xml.pelunasan do
      xml.noso acq.sale.no_so
      xml.nopelunasan acq.no_reference
      xml.TglPelunasan acq.created_at.strftime("%m/%d/%Y")
      xml.KeteranganSO acq.sale.keterangan_customer
      xml.NoPo acq.sale.no_so
      xml.AlamatKirim acq.sale.pos_ultimate_customer.alamat
      xml.Customer acq.sale.pos_ultimate_customer.nama
      xml.Alamat1 acq.sale.pos_ultimate_customer.alamat
      xml.KodePameran acq.sale.channel_customer.kode_channel_customer
      xml.NamaPameran acq.sale.channel_customer.nama.upcase
      siscc = acq.sale.channel_customer
      xml.DariTanggal siscc.dari_tanggal.nil? ? '' : siscc.dari_tanggal.strftime("%m/%d/%Y")
      xml.SampaiTanggal siscc.sampai_tanggal.nil? ? '' : siscc.sampai_tanggal.strftime("%m/%d/%Y")
      xml.AsalSo acq.sale.channel_customer.channel.channel
      xml.SPG acq.sale.sales_promotion_id.nil? ? @user.nama.titleize : acq.sale.channel_customer.sales_promotions.find(acq.sale.sales_promotion_id).nama.titleize
      xml.Phone acq.sale.pos_ultimate_customer.no_telepon
      xml.Hp1 acq.sale.pos_ultimate_customer.handphone.blank? ? '-' : acq.sale.pos_ultimate_customer.handphone
      xml.Hp2 acq.sale.pos_ultimate_customer.handphone1.blank? ? '-' : acq.sale.pos_ultimate_customer.handphone1
      xml.HargaNetto acq.sale.netto
      debit = PaymentWithDebitCard.find_by_sale_id(acq.sale)
      dp_before = acq.sale.pembayaran+debit.jumlah+acq.sale.payment_with_credit_cards.sum(:jumlah)+acq.sale.jumlah_transfer
      dp_now = (acq.cash_amount+acq.acquittance_with_debit_card.jumlah+acq.acquittance_with_credit_cards.sum(:jumlah)+acq.transfer_amount)
      xml.DP (dp_before + dp_now)
      xml.Sisa acq.sale.sisa
      xml.TipePembayaran acq.method_of_payment
      xml.Tunai acq.cash_amount
      xml.no_kartu_debit acq.acquittance_with_debit_card.no_kartu_debit.blank? ? '-' : acq.acquittance_with_debit_card.no_kartu_debit
      xml.nama_kartu_debit acq.acquittance_with_debit_card.nama_kartu.blank? ? '-' : acq.acquittance_with_debit_card.nama_kartu
      xml.atas_nama_debit acq.acquittance_with_debit_card.atas_nama.blank? ? '-' : acq.acquittance_with_debit_card.atas_nama
      xml.JumlahDebit acq.acquittance_with_debit_card.jumlah
      xml.NoMerchant acq.acquittance_with_credit_cards.first.no_merchant.blank? ? '-' : acq.acquittance_with_credit_cards.first.mid
      xml.NoKartu acq.acquittance_with_credit_cards.first.no_kartu_kredit.blank? ? '-' : acq.acquittance_with_credit_cards.first.no_kartu_kredit
      xml.NamaKartu acq.acquittance_with_credit_cards.first.nama_kartu.blank? ? '-' : acq.acquittance_with_credit_cards.first.nama_kartu
      xml.AtasNama acq.acquittance_with_credit_cards.first.atas_nama.blank? ? '-' : acq.acquittance_with_credit_cards.first.atas_nama
      xml.JumlahKredit acq.acquittance_with_credit_cards.first.jumlah
      xml.NoMerchant1 acq.acquittance_with_credit_cards.last.no_merchant.blank? ? '-' : acq.acquittance_with_credit_cards.last.mid
      xml.NoKartu1 acq.acquittance_with_credit_cards.last.no_kartu_kredit.blank? ? '-' : acq.acquittance_with_credit_cards.last.no_kartu_kredit
      xml.NamaKartu1 acq.acquittance_with_credit_cards.last.nama_kartu.blank? ? '-' : acq.acquittance_with_credit_cards.last.nama_kartu
      xml.AtasNama1 acq.acquittance_with_credit_cards.last.atas_nama.blank? ? '-' : acq.acquittance_with_credit_cards.last.atas_nama
      xml.JumlahKredit1 acq.acquittance_with_credit_cards.last.jumlah
      xml.NamaRekening acq.bank_account.nil? ? '-' : acq.bank_account.name
      xml.NoRekening acq.bank_account.nil? ? '-' : acq.bank_account.account_number
      xml.JumlahTransfer acq.transfer_amount
    end
  end
end
xml_data = xml.target!
set_file_name = "P" + Time.now.strftime("%d%m%Y%H%M%S")
file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
file.write(xml_data)
file.close
@acquittance.each do |acq_user|
  acq_user.update_attributes!(exported: true, exported_by: @user.id, exported_at: Time.now)
  UserMailer.pelunasan(acq_user.sale.channel_customer.recipients.first.sales_counter.email, "#{set_file_name}", @user).deliver_now
end