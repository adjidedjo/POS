class SaleItem < ActiveRecord::Base
  belongs_to :sale
  belongs_to :user

  validates :tanggal_kirim, presence: true, unless: "taken?"
  validates :serial, uniqueness: true, if: "serial.present?"

  before_create do
    if taken == true
      self.tanggal_kirim = Date.today
    end

    self.brand_id = Item.find_by_kode_barang(self.kode_barang).brand_id

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
    if serial.present?
      item = ExhibitionStockItem.find_by_serial(serial)
      item.update_attributes(jumlah: (jumlah - 1))
    end
  end
end