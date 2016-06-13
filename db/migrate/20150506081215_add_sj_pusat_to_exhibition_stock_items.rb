class AddSjPusatToExhibitionStockItems < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :sj_pusat, :string
  end
end
