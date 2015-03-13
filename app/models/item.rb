class Item < ActiveRecord::Base
  has_many :exhibition_stock_items, primary_key: :kode_barang, foreign_key: :kode_barang
end
