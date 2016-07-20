class Adjusment < ActiveRecord::Base

  validates :no_sj, :jumlah, :alasan, :nama_channel, presence: true
  validate :check_item

  def check_item
    errors.add(:kode_barang, "Barang Tidak Terdaftar, hubungi Admin!") if SqlItemMaster.where(kodebrg: self.kode_barang).empty?
  end

  before_create do
    showroom = ChannelCustomer.where(nama: self.nama_channel).first
    self.channel_customer_id = showroom.id
    self.kode_barang = self.kode_barang.upcase
    self.alasan = self.alasan.upcase
    self.no_sj = self.no_sj.upcase
  end

  after_create do
    showroom = ChannelCustomer.where(nama: self.nama_channel).first
    if showroom.present?
      serial = ExhibitionStockItem.where(channel_customer_id: showroom.id, serial: self.serial)
      kode = ExhibitionStockItem.where(channel_customer_id: showroom.id, kode_barang: self.kode_barang)
      item = Item.where(kode_barang: self.kode_barang)
      if item.empty?
        item_riches = SqlItemMaster.where("kodebrg like '#{self.kode_barang}'")
        item_riches.each do |a|
          @kode =  a.KodeBrg
          @nama =  a.Nama
        end
        Item.create(kode_barang: @kode, nama: @nama, jenis: @kode[0..1], harga: 0)
      end
      kode_item = Item.where(kode_barang: self.kode_barang)
      if serial.present?
        serial.first.update_attributes!(jumlah: 1) if (self.serial.present? && self.kode_barang.blank?) || (self.serial.present? && self.kode_barang.present?)
      elsif kode.present? && serial.nil?
        kode.first.update_attributes!(jumlah: (kode.first.jumlah + self.jumlah.to_i)) if self.serial.blank? && self.kode_barang.present?
      else
        ExhibitionStockItem.create!(kode_barang: self.kode_barang, serial: self.serial, channel_customer_id: showroom.id,
          jumlah: self.jumlah.to_i, no_sj: self.no_sj, checked_in: true, nama: @nama)
      end
      if self.serial.present?
        creating_item_mutation(showroom, (kode_item.empty? ? @ra : kode_item.first.nama), self.jumlah)
      else
        creating_item_mutation(showroom, (kode_item.empty? ? @ra : kode_item.first.nama), self.jumlah)
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
