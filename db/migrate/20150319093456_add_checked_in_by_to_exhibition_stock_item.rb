class AddCheckedInByToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :checked_in_by, :integer
    rename_column :exhibition_stock_items, :checked, :checked_in
  end
end
