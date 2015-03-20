class AddNamaToExhibitionStockItem < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :nama, :string
  end
end
