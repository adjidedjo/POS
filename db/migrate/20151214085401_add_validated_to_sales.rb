class AddValidatedToSales < ActiveRecord::Migration
  def change
    add_column :sales, :validated, :boolean, :default => 0
  end
end
