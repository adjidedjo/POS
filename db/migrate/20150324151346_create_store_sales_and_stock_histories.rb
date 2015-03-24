class CreateStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    create_table :store_sales_and_stock_histories do |t|
      t.integer :exhibition_id, :default => 0
      t.string :kode_barang
      t.string :nama
      t.string :no_sj
      t.date :tanggal, :default => '0000-00-00'
      t.integer :qty_in, :default => 0
      t.integer :qty_out, :default => 0
      t.string :keterangan

      t.timestamps null: false
    end
  end
end
