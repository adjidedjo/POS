class CreateSalesPromotions < ActiveRecord::Migration
  def change
    create_table :sales_promotions do |t|
      t.string :nama
      t.string :email
      t.string :nik
      t.integer :store_id
      t.string :regex

      t.timestamps null: false
    end
  end
end
