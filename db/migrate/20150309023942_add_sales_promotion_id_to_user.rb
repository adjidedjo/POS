class AddSalesPromotionIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :sales_promotion_id, :integer
  end
end
