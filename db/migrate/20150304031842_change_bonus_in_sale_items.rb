class ChangeBonusInSaleItems < ActiveRecord::Migration
  def change
    change_column :sale_items, :bonus, :boolean
  end
end
