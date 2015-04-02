class CreateChannelCustomers < ActiveRecord::Migration
  def change
    create_table :channel_customers do |t|
      t.string :kode_channel_customer
      t.integer :channel_id
      t.string :nama
      t.text :alamat
      t.date :dari_tanggal
      t.date :sampai_tanggal

      t.timestamps null: false
    end
  end
end
