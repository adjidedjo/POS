class CreatePosUltimateCustomers < ActiveRecord::Migration
  def change
    create_table :pos_ultimate_customers do |t|
      t.string :nama
      t.text :alamat
      t.string :email
      t.string :no_telepon
      t.string :handphone
      t.string :handphone1
      t.string :kode_customer

      t.timestamps null: false
    end
  end
end
