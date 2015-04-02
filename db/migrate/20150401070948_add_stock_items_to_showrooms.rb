class AddStockItemsToShowrooms < ActiveRecord::Migration
  def change
    add_column :showrooms, :stock_items, :string
  end
end
