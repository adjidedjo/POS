class AddAddressToShowrooms < ActiveRecord::Migration
  def change
    add_column :showrooms, :address, :text
  end
end
