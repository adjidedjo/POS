class SaleItem < ActiveRecord::Base
  belongs_to :sale
  belongs_to :user

  validates :serial, uniqueness: true, if: "serial.present?"

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

      if taken? && serial.blank?
        cek_stock = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0 and
checked_in = true and checked_out = false", self.sale.channel_customer_id, kode_barang).first
        if cek_stock.present?
          self.ex_no_sj = cek_stock.no_sj
          if cek_stock.serial.present?
            self.serial = cek_stock.serial
          end
        end
      end

      get_brand_id = Item.find_by_kode_barang(self.kode_barang)
      if get_brand_id.nil?
        brand_id = Brand.find_by_id_brand(self.kode_barang[2]).id
        self.brand_id = brand_id
      else
        self.brand_id = get_brand_id.brand_id
      end

      #    no_sale = self.sale.no_sale.to_s.rjust(4, '0')
      #    bulan = Date.today.strftime('%m')
      #    tahun = Date.today.strftime('%y')
      #    kode_barang = self.kode_barang.slice(2)
      #    kode_customer = self.sale.store.kode_customer
      #    kode_cabang = self.sale.store.branch.id.to_s.rjust(2, '0')
      #    self.no_so = 'SO'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
      #    self.no_ppb = 'PPB'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
      #    self.no_faktur = 'FK'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
      #    self.no_sj = 'SJ'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
    end

    after_create do
      cek_stock = ExhibitionStockItem.where("channel_customer_id = ? and kode_barang = ? and jumlah > 0
and checked_in = true and checked_out = false", self.sale.channel_customer_id, self.kode_barang).first
      if self.serial.present? && cek_stock.present?
        cek_stock.update_attributes(jumlah: (cek_stock.jumlah - self.jumlah))
        get_no_sj_from_serial = ExhibitionStockItem.find_by_serial(self.serial)
        StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
          nama: self.nama_barang, tanggal: Time.now, qty_out: self.jumlah, keterangan: "S", no_sj: get_no_sj_from_serial.no_sj,
          serial: get_no_sj_from_serial.serial)
      elsif self.serial.blank? && self.ex_no_sj.present? && cek_stock.present?
        cek_stock.update_attributes(jumlah: (cek_stock.jumlah - self.jumlah))
        StoreSalesAndStockHistory.create(channel_customer_id: self.sale.channel_customer_id, kode_barang: self.kode_barang,
          nama: self.nama_barang, tanggal: Time.now, qty_out: self.jumlah, keterangan: "S", no_sj: self.ex_no_sj)
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