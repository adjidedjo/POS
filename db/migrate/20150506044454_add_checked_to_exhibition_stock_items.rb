class AddCheckedToExhibitionStockItems < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :checked, :boolean
  end
end
