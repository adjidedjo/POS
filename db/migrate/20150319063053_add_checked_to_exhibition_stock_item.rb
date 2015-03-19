class AddCheckedToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :checked, :boolean, :default => 0
  end
end