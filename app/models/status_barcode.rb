class StatusBarcode < ActiveRecord::Base
  belongs_to :item, foreign_key: :kode_barang, primary_key: :kode_barang
end
