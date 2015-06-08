class SaleItem < ActiveRecord::Base
  belongs_to :sale, inverse_of: :sale_items
  belongs_to :user

  validates :serial, uniqueness: true, if: "serial.present?"
    validates :kode_barang, :jumlah, presence: true
    validates :jumlah, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1
    }

    before_create do
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
    end

    after_create do
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
                last_stock = jumlah_beli - stock_awal
                s_noserial.update_attributes!(jumlah: 0)
                st = stock_awal
              else
                last_stock = stock_awal - jumlah_beli
                s_noserial.update_attributes!(jumlah: last_stock)
                st = jumlah_beli
              end
              @exsj << s_noserial.no_sj
              StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
                nama: self.nama_barang, tanggal: Time.now, qty_out: st, keterangan: "S", no_sj: s_noserial.no_sj, sale_id: self.sale.id,
                serial: (s_noserial.serial.blank? ? '-' : s_noserial.serial))
              jumlah_beli = last_stock
            end
            break if jumlah_beli <= 0
          end
          self.update_attributes!(ex_no_sj: @exsj.join(', '))
        end
      end

      cek_stock = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0
and checked_in = true and checked_out = false", self.sale.channel_customer_id, self.kode_barang).first
      if self.serial.present? && cek_stock.present?
        cek_stock.update_attributes(jumlah: (cek_stock.jumlah - self.jumlah))
        get_no_sj_from_serial = ExhibitionStockItem.find_by_serial(self.serial)
        StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
          nama: self.nama_barang, tanggal: Time.now, qty_out: self.jumlah, keterangan: "S", no_sj: get_no_sj_from_serial.no_sj,
          serial: get_no_sj_from_serial.serial, sale_id: self.sale.id)
      end
    end

    before_destroy do
      esi = ExhibitionStockItem.find_by_kode_barang_and_serial_and_checked_out_and_channel_customer_id(self.kode_barang,
        self.serial, false, self.sale.channel_customer_id)
      ssah = StoreSalesAndStockHistory.where(kode_barang: self.kode_barang, no_sj: self.ex_no_sj).first
      if self.serial.present?
        esi.update_attributes(jumlah: (self.jumlah + esi.jumlah))
        ssah.destroy
      end
    end
  end