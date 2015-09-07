class SaleItem < ActiveRecord::Base
  belongs_to :sale, inverse_of: :sale_items
  belongs_to :user
  belongs_to :channel_customer
  belongs_to :item, foreign_key: :kode_barang, primary_key: :kode_barang

  validates :serial, uniqueness: true, if: "serial.present?"
  validates :kode_barang, :jumlah, presence: true
  validates :jumlah, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }
  validate :cek_stock_without_serial, on: :create
  validate :cek_stock_with_serial, on: :create
  validate :cek_sales_counter

  def cek_sales_counter
    item = Item.find_by_kode_barang(self.kode_barang)
    if item.present?
      recipient_brand_id = self.sale.channel_customer.recipients.find_by_brand_id(item.brand_id)
      if recipient_brand_id.nil?
        errors.add(:sales_promotion_id, "SALES COUNTER UNTUK BARANG YANG DI ORDER BELUM ADA")
      end
    end
  end

  def cek_stock_with_serial
    if taken == true && serial.present?
      esi =  ExhibitionStockItem.find_by_channel_customer_id_and_kode_barang_and_serial(self.sale.channel_customer_id, kode_barang, serial)
      if esi.nil?
        errors.add(:serial, "SERIAL YANG ANDA PILIH TIDAK TERSEDIA, SILAHKAN CEK STOK")
      end
    end
  end

  def cek_stock_without_serial
    if taken == true && serial.blank?
      esi =  ExhibitionStockItem.where("channel_customer_id = ? and kode_barang like ?", self.sale.channel_customer_id, kode_barang)
      if self.jumlah.to_i > esi.sum("jumlah").to_i
        errors.add(:kode_barang, "JUMLAH STOK #{kode_barang} KURANG DARI JUMLAH ORDER")
      end
    end
  end

  before_create do
    if kode_barang.include?("T")
      p = kode_barang[12..14]
      l = kode_barang[15..18]
      self.nama_barang = nama_barang.gsub(/\b#{nama_barang[-9..-7]}\b/, p).gsub(/\b#{nama_barang[-3..-1]}\b/, l)
    end

    self.channel_customer_id = self.sale.channel_customer_id
    if taken == true
      self.tanggal_kirim = Date.today
    else
      self.tanggal_kirim = self.sale.tanggal_kirim.to_date
    end

    if serial.present?
      get_ex_no_sj = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang like ? and jumlah > ?",
        self.sale.channel_customer_id, kode_barang, 0).first
      self.ex_no_sj = get_ex_no_sj.no_sj
     end

    get_brand_id = Item.find_by_kode_barang(self.kode_barang)
    if get_brand_id.nil?
      brand_id = Brand.find_by_id_brand(self.kode_barang[2]).id
      self.brand_id = brand_id
    else
      self.brand_id = get_brand_id.brand_id
    end
    update_price_list
  end

  after_create do
    add_sale_item_to_history
  end

  before_destroy do
    remove_sale_item
  end

  before_update do
    if jumlah_changed?
      sale_item_jumlah = SaleItem.find(self.id).jumlah.to_i
      if jumlah > sale_item_jumlah
        jumlah_now = jumlah - sale_item_jumlah
        esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out_and_channel_customer_id(kode_barang,
            serial, false, self.sale.channel_customer_id)
        ssa = StoreSalesAndStockHistory.find_by_sale_id_and_kode_barang_and_keterangan(self.sale.id, kode_barang, "S")
        ssa.update_attributes!(qty_out: (ssa.qty_out + jumlah_now))
        esi.update_attributes!(jumlah: (esi.jumlah - jumlah_now))
      else
        jumlah_now = sale_item_jumlah - jumlah
        esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out_and_channel_customer_id(kode_barang,
            serial, false, self.sale.channel_customer_id)
        ssa = StoreSalesAndStockHistory.find_by_sale_id_and_kode_barang_and_keterangan(self.sale.id, kode_barang, "S")
        ssa.update_attributes!(qty_out: (ssa.qty_out - jumlah_now))
        esi.update_attributes!(jumlah: (esi.jumlah + jumlah_now))
      end
    end
    if serial.present? && _destroy == false
      get_ex_no_sj = ExhibitionStockItem.where("serial = ? and channel_customer_id = ? and kode_barang like ?",
        serial, self.sale.channel_customer_id, kode_barang).first
      self.ex_no_sj = get_ex_no_sj.no_sj.present? ? get_ex_no_sj.no_sj : '-'
    end
  end

  def remove_sale_item
    sale.sale_items.each do |ssi|
      if ssi._destroy == true
        if ssi.serial.present? || ssi.taken?
          esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out_and_channel_customer_id(self.kode_barang,
            self.serial, false, self.sale.channel_customer_id)
          ssah = StoreSalesAndStockHistory.where(kode_barang: self.kode_barang, no_sj: self.ex_no_sj).first
          esi.update_attributes(jumlah: (self.jumlah + esi.jumlah))
          ssah.destroy
        end
      end
    end
  end

  def add_sale_item_to_history
    if self.taken? && self.serial.blank?
      stock = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0
and checked_in = true and checked_out = false", self.sale.channel_customer_id, self.kode_barang)
      @exsj = []
      jumlah_beli = self.jumlah

      if stock.first.serial.present?
        (1..jumlah_beli).each do |sp|
          s_serial = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0
and checked_in = true and checked_out = false", self.sale.channel_customer_id, self.kode_barang).first
          last_stock = s_serial.jumlah - 1
          s_serial.update_attributes!(jumlah: last_stock)
          @exsj << s_serial.no_sj
          StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
            nama: self.nama_barang, tanggal: Time.now, qty_out: jumlah_beli, keterangan: "S", no_sj: s_serial.no_sj, sale_id: self.sale.id,
            serial: s_serial.serial)
          jumlah_beli = jumlah_beli -1
          break if jumlah_beli == 0
        end
        self.update_attributes!(ex_no_sj: @exsj.join(', '))
      else
        count_stock = stock.count
        (1..count_stock).each do |stok_no_serial|
          s_noserial = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0
and checked_in = true and checked_out = false", self.sale.channel_customer_id, self.kode_barang).first
          if jumlah_beli > 0
            stock_awal = s_noserial.jumlah
            if jumlah_beli > stock_awal
              sisa_jumlah_beli = jumlah_beli - stock_awal
              jumlah_beli_pertama = jumlah_beli - sisa_jumlah_beli
              last_stock = ((jumlah_beli - (jumlah_beli - stock_awal)) - stock_awal)
              s_noserial.update_attributes!(jumlah: last_stock)
              st = sisa_jumlah_beli
            else
              last_stock = stock_awal - jumlah_beli
              jumlah_beli_pertama = jumlah_beli
              s_noserial.update_attributes!(jumlah: last_stock)
              st = 0
            end
            @exsj << s_noserial.no_sj
            StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
              nama: self.nama_barang, tanggal: Time.now, qty_out: jumlah_beli_pertama, keterangan: "S", no_sj: s_noserial.no_sj, sale_id: self.sale.id,
              serial: (s_noserial.serial.blank? ? '-' : s_noserial.serial))
            jumlah_beli = st
          end
          break if jumlah_beli <= 0
        end
        self.update_attributes!(ex_no_sj: @exsj.join(', '))
      end
    end

    if self.serial.present?
      get_no_sj_from_serial = ExhibitionStockItem.find_by_serial_and_channel_customer_id(self.serial, self.channel_customer_id)
      get_no_sj_from_serial.update_attributes!(jumlah: (get_no_sj_from_serial.jumlah - self.jumlah))
      StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
        nama: self.nama_barang, tanggal: Time.now, qty_out: self.jumlah, keterangan: "S", no_sj: get_no_sj_from_serial.no_sj,
        serial: get_no_sj_from_serial.serial, sale_id: self.sale.id)
    end
  end

  def update_price_list
    brand_id = Item.find_by_kode_barang(self.kode_barang).brand_id
    recipient_brand_id = self.sale.channel_customer.recipients.find_by_brand_id(brand_id)
    branch_id = recipient_brand_id.sales_counter.branch.id
    regional_branch = RegionalBranch.find_by_cabang_id(branch_id)
    regional = Regional.find(regional_branch.regional_id)
    price_list = PriceList.find_by_regional_id_and_kode_barang(regional.id, self.kode_barang)
    self.price_list = price_list.nil? ? 0 : price_list.harga
  end
end
