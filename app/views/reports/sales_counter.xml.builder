xml = Builder::XmlMarkup.new
xml.instruct!
sale_item_by_brand = SaleItem.where(id: @chosen_sale_item)
xml.data do
  sale_item_by_brand.each do |sale_item|
    if sale_item.taken == true && sale_item.serial.present?
      StoreSalesAndStockHistory.where(sale_id: sale_item.sale.id, keterangan: "S", kode_barang: sale_item.kode_barang, serial: sale_item.serial).each do |items|
        xml.pbjshow do
          xml.ExSJ items.no_sj.blank? ? '-' : items.no_sj
          xml.kodebrg items.kode_barang
          xml.namabrg items.nama
          xml.qty items.qty_out
          xml.status 1
          xml.satuan "PCS"
          xml.created sale_item.created_at.strftime('%m/%d/%Y')
          xml.createdby SalesPromotion.find(sale_item.sale.sales_promotion_id).nama.capitalize
          xml.bonus sale_item.bonus? ? 'BONUS' : '-'
          xml.noso sale_item.sale.no_so
          xml.KeteranganSO sale_item.sale.keterangan_customer
          xml.NoPo sale_item.sale.no_so
          xml.keterangan sale_item.keterangan.blank? ? "-"  : sale_item.keterangan
          xml.TglDelivery sale_item.tanggal_kirim.strftime("%m/%d/%Y")
          xml.AlamatKirim sale_item.sale.pos_ultimate_customer.alamat+" "+ sale_item.sale.pos_ultimate_customer.kota.capitalize
          xml.Customer sale_item.sale.pos_ultimate_customer.nama
          xml.Alamat1 sale_item.sale.pos_ultimate_customer.alamat
          xml.KodePameran sale_item.sale.channel_customer.kode_channel_customer
          xml.NamaPameran sale_item.sale.channel_customer.nama
          siscc = sale_item.sale.channel_customer
          xml.DariTanggal siscc.dari_tanggal.nil? ? '' : siscc.dari_tanggal.strftime("%m/%d/%Y")
          xml.SampaiTanggal siscc.sampai_tanggal.nil? ? '' : siscc.sampai_tanggal.strftime("%m/%d/%Y")
          xml.AsalSo sale_item.sale.channel_customer.channel.channel
          xml.SPG sale_item.sale.sales_promotion_id.nil? ? @user.channel_customer.nama.titleize :
            sale_item.sale.channel_customer.sales_promotions.find(sale_item.sale.sales_promotion_id).nama.titleize
          xml.Taken (sale_item.taken? ? 'Y' : 'T')
          xml.Serial sale_item.serial.blank? ? '-' : sale_item.serial
          item = Item.find_by_kode_barang(sale_item.kode_barang)
          xml.PriceList item.nil? ? '0' : item.harga
          xml.Voucher sale_item.sale.voucher
          xml.Phone sale_item.sale.pos_ultimate_customer.no_telepon
          xml.Hp1 sale_item.sale.pos_ultimate_customer.handphone.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone
          xml.Hp2 sale_item.sale.pos_ultimate_customer.handphone1.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone1
          xml.HargaNetto sale_item.sale.netto
          dp = (sale_item.sale.pembayaran+sale_item.sale.payment_with_debit_cards.sum(:jumlah)+sale_item.sale.payment_with_credit_cards.sum(:jumlah)+sale_item.sale.jumlah_transfer)
          xml.DP dp
          xml.Sisa sale_item.sale.sisa
          xml.TipePembayaran sale_item.sale.tipe_pembayaran
          xml.Tunai sale_item.sale.pembayaran
          xml.no_kartu_debit sale_item.sale.payment_with_debit_cards.first.no_kartu_debit.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.no_kartu_debit
          xml.nama_kartu_debit sale_item.sale.payment_with_debit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.nama_kartu
          xml.atas_nama_debit sale_item.sale.payment_with_debit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.atas_nama
          xml.JumlahDebit sale_item.sale.payment_with_debit_cards.first.jumlah
          xml.NoMerchant sale_item.sale.payment_with_credit_cards.first.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.mid
          xml.NoKartu sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit
          xml.NamaKartu sale_item.sale.payment_with_credit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.nama_kartu
          xml.AtasNama sale_item.sale.payment_with_credit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.atas_nama
          xml.JumlahKredit sale_item.sale.payment_with_credit_cards.first.jumlah
          xml.NoMerchant1 sale_item.sale.payment_with_credit_cards.last.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.mid
          xml.NoKartu1 sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit
          xml.NamaKartu1 sale_item.sale.payment_with_credit_cards.last.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.nama_kartu
          xml.AtasNama1 sale_item.sale.payment_with_credit_cards.last.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.atas_nama
          xml.JumlahKredit1 sale_item.sale.payment_with_credit_cards.last.jumlah
          xml.Email sale_item.sale.email
          netto_brand = sale_item.brand_id == 2 ? sale_item.sale.netto_elite : sale_item.sale.netto_lady
          xml.NettoBrand netto_brand
          xml.NamaRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.name
          xml.NoRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.account_number
          xml.JumlahTransfer sale_item.sale.jumlah_transfer
        end
      end
    elsif sale_item.taken == true && sale_item.serial.blank?
      StoreSalesAndStockHistory.where(sale_id: sale_item.sale.id, keterangan: "S", kode_barang: sale_item.kode_barang).each do |items|
        xml.pbjshow do
          xml.ExSJ items.no_sj.blank? ? '-' : items.no_sj
          xml.kodebrg items.kode_barang
          xml.namabrg items.nama
          xml.qty items.qty_out
          xml.status 1
          xml.satuan "PCS"
          xml.created sale_item.created_at.strftime('%m/%d/%Y')
          xml.createdby SalesPromotion.find(sale_item.sale.sales_promotion_id).nama.capitalize
          xml.bonus sale_item.bonus? ? 'BONUS' : '-'
          xml.noso sale_item.sale.no_so
          xml.KeteranganSO sale_item.sale.keterangan_customer
          xml.NoPo sale_item.sale.no_so
          xml.keterangan sale_item.keterangan.blank? ? "-"  : sale_item.keterangan
          xml.TglDelivery sale_item.tanggal_kirim.strftime("%m/%d/%Y")
          xml.AlamatKirim sale_item.sale.pos_ultimate_customer.alamat+" "+ sale_item.sale.pos_ultimate_customer.kota.capitalize
          xml.Customer sale_item.sale.pos_ultimate_customer.nama
          xml.Alamat1 sale_item.sale.pos_ultimate_customer.alamat
          xml.KodePameran sale_item.sale.channel_customer.kode_channel_customer
          xml.NamaPameran sale_item.sale.channel_customer.nama
          siscc = sale_item.sale.channel_customer
          xml.DariTanggal siscc.dari_tanggal.nil? ? '' : siscc.dari_tanggal.strftime("%m/%d/%Y")
          xml.SampaiTanggal siscc.sampai_tanggal.nil? ? '' : siscc.sampai_tanggal.strftime("%m/%d/%Y")
          xml.AsalSo sale_item.sale.channel_customer.channel.channel
          xml.SPG sale_item.sale.sales_promotion_id.nil? ? @user.channel_customer.nama.titleize :
            sale_item.sale.channel_customer.sales_promotions.find(sale_item.sale.sales_promotion_id).nama.titleize
          xml.Taken (sale_item.taken? ? 'Y' : 'T')
          xml.Serial sale_item.serial.blank? ? '-' : sale_item.serial
          item = Item.find_by_kode_barang(sale_item.kode_barang)
          xml.PriceList item.nil? ? '0' : item.harga
          xml.Voucher sale_item.sale.voucher
          xml.Phone sale_item.sale.pos_ultimate_customer.no_telepon
          xml.Hp1 sale_item.sale.pos_ultimate_customer.handphone.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone
          xml.Hp2 sale_item.sale.pos_ultimate_customer.handphone1.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone1
          xml.HargaNetto sale_item.sale.netto
          dp = (sale_item.sale.pembayaran+sale_item.sale.payment_with_debit_cards.sum(:jumlah)+sale_item.sale.payment_with_credit_cards.sum(:jumlah)+sale_item.sale.jumlah_transfer)
          xml.DP dp
          xml.Sisa sale_item.sale.sisa
          xml.TipePembayaran sale_item.sale.tipe_pembayaran
          xml.Tunai sale_item.sale.pembayaran
          xml.no_kartu_debit sale_item.sale.payment_with_debit_cards.first.no_kartu_debit.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.no_kartu_debit
          xml.nama_kartu_debit sale_item.sale.payment_with_debit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.nama_kartu
          xml.atas_nama_debit sale_item.sale.payment_with_debit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.atas_nama
          xml.JumlahDebit sale_item.sale.payment_with_debit_cards.first.jumlah
          xml.NoMerchant sale_item.sale.payment_with_credit_cards.first.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.mid
          xml.NoKartu sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit
          xml.NamaKartu sale_item.sale.payment_with_credit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.nama_kartu
          xml.AtasNama sale_item.sale.payment_with_credit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.atas_nama
          xml.JumlahKredit sale_item.sale.payment_with_credit_cards.first.jumlah
          xml.NoMerchant1 sale_item.sale.payment_with_credit_cards.last.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.mid
          xml.NoKartu1 sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit
          xml.NamaKartu1 sale_item.sale.payment_with_credit_cards.last.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.nama_kartu
          xml.AtasNama1 sale_item.sale.payment_with_credit_cards.last.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.atas_nama
          xml.JumlahKredit1 sale_item.sale.payment_with_credit_cards.last.jumlah
          xml.Email sale_item.sale.email
          netto_brand = sale_item.brand_id == 2 ? sale_item.sale.netto_elite : sale_item.sale.netto_lady
          xml.NettoBrand netto_brand
          xml.NamaRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.name
          xml.NoRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.account_number
          xml.JumlahTransfer sale_item.sale.jumlah_transfer
        end
      end
    else
      SaleItem.where(sale_id: sale_item.sale.id, kode_barang: sale_item.kode_barang).each do |items|
        xml.pbjshow do
          xml.ExSJ '-'
          xml.kodebrg items.kode_barang
          xml.namabrg items.nama_barang
          xml.qty items.jumlah
          xml.status 1
          xml.satuan "PCS"
          xml.created sale_item.created_at.strftime('%m/%d/%Y')
          xml.createdby SalesPromotion.find(sale_item.sale.sales_promotion_id).nama.capitalize
          xml.bonus sale_item.bonus? ? 'BONUS' : '-'
          xml.noso sale_item.sale.no_so
          xml.KeteranganSO sale_item.sale.keterangan_customer
          xml.NoPo sale_item.sale.no_so
          xml.keterangan sale_item.keterangan.blank? ? "-"  : sale_item.keterangan
          xml.TglDelivery sale_item.tanggal_kirim.strftime("%m/%d/%Y")
          xml.AlamatKirim sale_item.sale.pos_ultimate_customer.alamat+". "+ sale_item.sale.pos_ultimate_customer.kota.capitalize
          xml.Customer sale_item.sale.pos_ultimate_customer.nama
          xml.Alamat1 sale_item.sale.pos_ultimate_customer.alamat
          xml.KodePameran sale_item.sale.channel_customer.kode_channel_customer
          xml.NamaPameran sale_item.sale.channel_customer.nama
          siscc = sale_item.sale.channel_customer
          xml.DariTanggal siscc.dari_tanggal.nil? ? '' : siscc.dari_tanggal.strftime("%m/%d/%Y")
          xml.SampaiTanggal siscc.sampai_tanggal.nil? ? '' : siscc.sampai_tanggal.strftime("%m/%d/%Y")
          xml.AsalSo sale_item.sale.channel_customer.channel.channel
          xml.SPG sale_item.sale.sales_promotion_id.nil? ? @user.channel_customer.nama.titleize :
            sale_item.sale.channel_customer.sales_promotions.find(sale_item.sale.sales_promotion_id).nama.titleize
          xml.Taken (sale_item.taken? ? 'Y' : 'T')
          xml.Serial sale_item.serial.blank? ? '-' : sale_item.serial
          item = Item.find_by_kode_barang(sale_item.kode_barang)
          xml.PriceList item.nil? ? '0' : item.harga
          xml.Voucher sale_item.sale.voucher
          xml.Phone sale_item.sale.pos_ultimate_customer.no_telepon
          xml.Hp1 sale_item.sale.pos_ultimate_customer.handphone.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone
          xml.Hp2 sale_item.sale.pos_ultimate_customer.handphone1.blank? ? '-' : sale_item.sale.pos_ultimate_customer.handphone1
          xml.HargaNetto sale_item.sale.netto
          dp = (sale_item.sale.pembayaran+sale_item.sale.payment_with_debit_cards.sum(:jumlah)+sale_item.sale.payment_with_credit_cards.sum(:jumlah)+sale_item.sale.jumlah_transfer)
          xml.DP dp
          xml.Sisa sale_item.sale.sisa
          xml.TipePembayaran sale_item.sale.tipe_pembayaran
          xml.Tunai sale_item.sale.pembayaran
          xml.no_kartu_debit sale_item.sale.payment_with_debit_cards.first.no_kartu_debit.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.no_kartu_debit
          xml.nama_kartu_debit sale_item.sale.payment_with_debit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.nama_kartu
          xml.atas_nama_debit sale_item.sale.payment_with_debit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_debit_cards.first.atas_nama
          xml.JumlahDebit sale_item.sale.payment_with_debit_cards.first.jumlah
          xml.NoMerchant sale_item.sale.payment_with_credit_cards.first.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.mid
          xml.NoKartu sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.no_kartu_kredit
          xml.NamaKartu sale_item.sale.payment_with_credit_cards.first.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.nama_kartu
          xml.AtasNama sale_item.sale.payment_with_credit_cards.first.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.first.atas_nama
          xml.JumlahKredit sale_item.sale.payment_with_credit_cards.first.jumlah
          xml.NoMerchant1 sale_item.sale.payment_with_credit_cards.last.no_merchant.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.mid
          xml.NoKartu1 sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.no_kartu_kredit
          xml.NamaKartu1 sale_item.sale.payment_with_credit_cards.last.nama_kartu.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.nama_kartu
          xml.AtasNama1 sale_item.sale.payment_with_credit_cards.last.atas_nama.blank? ? '-' : sale_item.sale.payment_with_credit_cards.last.atas_nama
          xml.JumlahKredit1 sale_item.sale.payment_with_credit_cards.last.jumlah
          xml.Email sale_item.sale.email
          netto_brand = sale_item.brand_id == 2 ? sale_item.sale.netto_elite : sale_item.sale.netto_lady
          xml.NettoBrand netto_brand
          xml.NamaRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.name
          xml.NoRekening sale_item.sale.bank_account.nil? ? '' : sale_item.sale.bank_account.account_number
          xml.JumlahTransfer sale_item.sale.jumlah_transfer
        end
      end
    end
  end
  xml_data = xml.target!
  set_file_name = Time.now.strftime("%d%m%Y%H%M%S")
  file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
  file.write(xml_data)
  file.close
  @sales.group_by(&:brand_id).keys.each do |group|
    UserMailer.order_pameran(@user.recipients.find_by_brand_id(group).sales_counter.email, "#{set_file_name}", @user).deliver_now
  end
end