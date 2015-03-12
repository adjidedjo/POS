class AddMailedToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :mailed_to, :string
  end
end
