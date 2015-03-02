class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.integer :sale_id
      t.string :kode_barang

      t.timestamps null: false
    end
  end
end
