class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :asal_so
      t.integer :salesman_id
      t.string :nota_bene
      t.text :keterangan_customer
      t.integer :venue_id
      t.string :spg
      t.string :customer
      t.string :phone_number
      t.string :hp1
      t.string :hp2
      t.text :alamat_kirim
      t.string :so_manual

      t.timestamps null: false
    end
  end
end
