class CreateWarehouseRecipients < ActiveRecord::Migration
  def change
    create_table :warehouse_recipients do |t|
      t.integer :warehouse_admin_id
      t.integer :channel_customer_id

      t.timestamps null: false
    end
  end
end
