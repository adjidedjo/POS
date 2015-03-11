class ChangeColumnSpgInSale < ActiveRecord::Migration
  def change
    change_column :sales, :sales_promotion_id, :integer
  end
end
