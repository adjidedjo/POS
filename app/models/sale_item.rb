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
        get_ex_no_sj = ExhibitionStockItem.where("kode_barang like ? and jumlah > ?", kode_barang, 0).first
        self.ex_no_sj = get_ex_no_sj.no_sj
      end

      if taken? && serial.blank?
        cek_stock = ExhibitionStockItem.where("kode_barang = ? and store_id = ? and jumlah > 0 and checked_in = true and checked_out = false", kode_barang, self.sale.store_id).first
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
      if self.serial.present?
        item = ExhibitionStockItem.find_by_serial(self.serial)
        item.update_attributes(jumlah: (item.jumlah - self.jumlah))
        cek_stock = ExhibitionStockItem.find_by_kode_barang_and_store_id(self.kode_barang, self.sale.store_id)
        get_no_sj_from_serial = ExhibitionStockItem.find_by_serial(self.serial).no_sj
        if cek_stock.present?
          StoreSalesAndStockHistory.create(exhibition_id: self.sale.store_id, kode_barang: self.kode_barang, nama: self.nama_barang, tanggal: Date.today, qty_out: self.jumlah, keterangan: "S", no_sj: get_no_sj_from_serial)
        end
      end
    end
  end