class ChangeColumnStoreIdOnSalesPromotions < ActiveRecord::Migration
  def change
    change_column :sales_promotions, :store_id, :integer
  end
end
