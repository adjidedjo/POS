class AddBonusToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :bonus, :string
  end
end
