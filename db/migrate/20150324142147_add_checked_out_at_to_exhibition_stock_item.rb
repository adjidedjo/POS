class AddCheckedOutAtToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :checked_out_at, :datetime
  end
end
