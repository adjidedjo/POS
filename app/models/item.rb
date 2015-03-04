class Item < ActiveRecord::Base
  has_many :status_barcode, primary_key: :kode_barang, foreign_key: :kode_barang
end
