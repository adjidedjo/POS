class AddBrandIdToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :brand_id, :integer
  end
end
