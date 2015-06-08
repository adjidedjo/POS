class Item < ActiveRecord::Base
  has_many :exhibition_stock_items, primary_key: :kode_barang, foreign_key: :kode_barang
  has_many :sale_items, primary_key: :kode_barang, foreign_key: :kode_barang

  before_create do
    self.brand_id = Brand.find_by_id_brand(kode_barang[2]).id
  end
end
