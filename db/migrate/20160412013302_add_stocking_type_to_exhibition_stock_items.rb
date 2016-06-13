class AddStockingTypeToExhibitionStockItems < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :stocking_type, :string
  end
end
