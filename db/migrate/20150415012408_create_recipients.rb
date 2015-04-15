class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.integer :sales_counter_id
      t.integer :channel_customer_id
      t.integer :brand_id

      t.timestamps null: false
    end
  end
end
