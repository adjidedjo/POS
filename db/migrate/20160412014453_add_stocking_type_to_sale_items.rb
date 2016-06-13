class AddStockingTypeToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :stocking_type, :string
  end
end
