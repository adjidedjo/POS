class CreateExhibitionStockItems < ActiveRecord::Migration
  def change
    create_table :exhibition_stock_items do |t|
      t.string :kode_barang
      t.string :serial
      t.string :no_so
      t.string :no_pbj
      t.string :no_sj
      t.date :tanggal_sj
      t.integer :store_id
      t.integer :jumlah

      t.timestamps null: false
    end
  end
end
