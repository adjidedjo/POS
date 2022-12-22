class AddVerifiedByToSale < ActiveRecord::Migration
  def change
    add_column :sales, :verified_by, :integer
    add_column :sales, :verified_at, :datetime
  end
end
