class ExhibitionStockItem < ActiveRecord::Base
  belongs_to :store
  belongs_to :item, foreign_key: :kode_barang, primary_key: :kode_barang

  after_create do
    cek_kode = StoreSalesAndStockHistory.find_by_kode_barang_and_no_sj_and_keterangan(self.kode_barang, self.no_sj,'R')
    if cek_kode.nil?
      StoreSalesAndStockHistory.create(exhibition_id: self.store_id, kode_barang: self.kode_barang, nama: self.nama, tanggal: self.created_at.to_date, qty_in: self.jumlah, qty_out: 0, keterangan: "R", no_sj: self.no_sj)
    else
      cek_kode.update_attributes(qty_in: (self.jumlah + cek_kode.qty_in))
    end
  end
end
