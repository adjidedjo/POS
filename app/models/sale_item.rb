class SaleItem < ActiveRecord::Base
  belongs_to :sale

  before_create do
    if taken == true
      self.tanggal_kirim = Date.today
    end
    no_sale = self.sale.no_sale.to_s.rjust(4, '0')
    bulan = Date.today.strftime('%m')
    tahun = Date.today.strftime('%y')
    kode_barang = self.kode_barang.slice(2)
    kode_customer = self.sale.store.kode_customer
    kode_cabang = self.sale.store.branch.id.to_s.rjust(2, '0')
    self.no_so = 'SO'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
    self.no_ppb = 'PPB'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
    self.no_faktur = 'FK'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
    self.no_sj = 'SJ'+kode_barang+'-'+kode_cabang+'-'+kode_customer+'-'+tahun+bulan+'-'+no_sale
  end
end