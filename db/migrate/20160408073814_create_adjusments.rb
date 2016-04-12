class CreateAdjusments < ActiveRecord::Migration
  def change
    create_table :adjusments do |t|
      t.integer :channel_customer_id
      t.string :kode_barang
      t.string :jumlah
      t.string :alasan

      t.timestamps null: false
    end
  end
end
