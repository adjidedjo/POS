class CreateStockItemExhibitions < ActiveRecord::Migration
  def change
    create_table :stock_item_exhibitions do |t|
      t.string :kode_barang
      t.string :nama_barang
      t.string :serial
      t.integer :stock
      t.integer :store_id

      t.timestamps null: false
    end
  end
end
