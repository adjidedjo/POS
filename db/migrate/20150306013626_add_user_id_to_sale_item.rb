class AddUserIdToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :user_id, :integer
  end
end
