xml = Builder::XmlMarkup.new
xml.instruct!
@nobukti = Time.now.strftime("%d%m%Y%H%M%S")
xml.data do
  @returned.each do |si|
    si.update_attributes!(no_bukti_return: @nobukti)
    xml.sj do
      xml.Kodebrg si.kode_barang
      xml.Serial si.serial.present? ? si.serial : si.qty_out
      xml.Noso si.sale_id.nil? ? '-' : si.sale_id
      xml.NoPBJ si.no_sj.present? ? si.no_sj : "-"
      xml.Status ""
      xml.NoSJ si.no_bukti_return.present? ? si.no_bukti_return : "-"
      xml.TglSJ si.tanggal.strftime('%m/%d/%Y')
      xml.KodePameran ChannelCustomer.find(si.channel_customer_id).kode_channel_customer
    end
  end
end
xml_data = xml.target!
set_file_name = @nobukti
file = File.new("#{Rails.root}/public/#{set_file_name}.xml", "wb")
file.write(xml_data)
file.close
recipient = ChannelCustomer.find(@returned.first.channel_customer_id)
recipient.warehouse_recipients.each do |receiper|
  UserMailer.return_stock(receiper.warehouse_admin.email, "#{set_file_name}", recipient.nama).deliver_now
end