class AddVerifiedToSale < ActiveRecord::Migration
  def change
    add_column :sales, :verified, :boolean, :default => 0
  end
end
