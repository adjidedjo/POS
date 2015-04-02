class AddShowroomIdToSalesPromotions < ActiveRecord::Migration
  def change
    add_column :sales_promotions, :showroom_id, :integer
  end
end
