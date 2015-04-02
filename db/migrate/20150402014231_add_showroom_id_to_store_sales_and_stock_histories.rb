class AddShowroomIdToStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :showroom_id, :integer
  end
end
