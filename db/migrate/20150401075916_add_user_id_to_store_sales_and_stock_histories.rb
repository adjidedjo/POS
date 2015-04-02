class AddUserIdToStoreSalesAndStockHistories < ActiveRecord::Migration
  def change
    add_column :store_sales_and_stock_histories, :user_id, :integer
  end
end
