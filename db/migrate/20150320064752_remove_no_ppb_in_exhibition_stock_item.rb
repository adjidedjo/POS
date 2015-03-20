class RemoveNoPpbInExhibitionStockItem < ActiveRecord::Migration
  def change
    remove_column :exhibition_stock_items, :no_ppb
  end
end
