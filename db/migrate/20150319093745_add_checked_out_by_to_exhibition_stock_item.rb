class AddCheckedOutByToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :checked_out_by, :integer
    add_column :exhibition_stock_items, :checked_out, :boolean, :default => 0
  end
end
