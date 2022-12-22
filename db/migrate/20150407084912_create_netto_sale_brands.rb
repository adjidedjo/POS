class CreateNettoSaleBrands < ActiveRecord::Migration
  def change
    create_table :netto_sale_brands do |t|
      t.integer :brand_id
      t.integer :sale_id
      t.decimal :netto

      t.timestamps null: false
    end
  end
end
