class AddNoPpbToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :no_ppb, :string
  end
end
