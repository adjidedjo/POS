class AddSalesPromotionIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sales_promotion_id, :integer
  end
end
