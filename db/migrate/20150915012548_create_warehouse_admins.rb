class CreateWarehouseAdmins < ActiveRecord::Migration
  def change
    create_table :warehouse_admins do |t|
      t.string :nik
      t.string :nama
      t.string :email
      t.string :branch_id

      t.timestamps null: false
    end
  end
end
