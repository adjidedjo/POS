class AddPriceListToExhibitionStockItems < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :price_list, :float
  end
end
