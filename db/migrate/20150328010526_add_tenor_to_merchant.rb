class AddTenorToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :tenor, :string
    add_column :merchants, :mid, :string
  end
end
