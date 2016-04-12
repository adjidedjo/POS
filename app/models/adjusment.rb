class Adjusment < ActiveRecord::Base

  validates :jumlah,  :alasan, :nama_channel, presence: true

  before_create do
    showroom = ChannelCustomer.where(nama: self.nama_channel).first
    self.channel_customer_id = showroom.id
    self.kode_barang = self.kode_barang.upcase
    self.alasan = self.alasan.upcase
  end

  after_create do
    showroom = ChannelCustomer.where(nama: self.nama_channel).first
    if showroom.present?
      serial = ExhibitionStockItem.where(channel_customer_id: showroom.id, serial: self.serial)
      kode = ExhibitionStockItem.where(channel_customer_id: showroom.id, kode_barang: self.kode_barang)
      nama = serial.present? ? serial.first.nama : kode.first.nama
      self.kode_barang = serial.first.kode_barang if self.kode_barang.blank?
      serial.first.update_attributes!(jumlah: (serial.first.jumlah.to_i + self.jumlah.to_i)) if (self.serial.present? && self.kode_barang.blank?) || (self.serial.present? && self.kode_barang.present?)
      kode.first.update_attributes!(jumlah: (kode.first.jumlah + self.jumlah.to_i)) if self.serial.blank? && self.kode_barang.present?
      if self.serial.present?
        creating_item_mutation(showroom, nama, self.jumlah)
      else
        creating_item_mutation(showroom, nama, self.jumlah)
      end
    end
  end

  def creating_item_mutation(showroom, nama, jumlah)
    if jumlah.to_i < 0
      StoreSalesAndStockHistory.create(channel_customer_id: showroom.id,
        kode_barang: self.kode_barang, nama: nama, tanggal: Time.now, qty_out: self.jumlah.to_i.abs, keterangan: "A",
        no_sj: ("ADJ" + "#{self.id}"), serial: (self.serial.present? ? self.serial : ""))
    else
      StoreSalesAndStockHistory.create(channel_customer_id: showroom.id,
        kode_barang: self.kode_barang, nama: nama, tanggal: Time.now, qty_in: self.jumlah, keterangan: "A",
        no_sj: ("ADJ" + "#{self.id}"), serial: (self.serial.present? ? self.serial : ""))
    end
  end
end
