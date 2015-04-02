class AddShowroomIdToExhibitionStockItems < ActiveRecord::Migration
  def change
    add_column :exhibition_stock_items, :showroom_id, :integer
  end
end
