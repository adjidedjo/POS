class CreateSearchSales < ActiveRecord::Migration
  def change
    create_table :search_sales do |t|
      t.string :keywords
      t.integer :channel_id
      t.integer :channel_customer_id
      t.string :cara_bayar

      t.timestamps null: false
    end
  end
end
