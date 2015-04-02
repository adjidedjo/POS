class ChangeColumnShowroomIdOnExhibitionStockItems < ActiveRecord::Migration
  def change
    change_column :exhibition_stock_items, :store_id, :integer
    change_column :exhibition_stock_items, :showroom_id, :integer
  end
end
