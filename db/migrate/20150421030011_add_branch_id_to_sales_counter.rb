class AddBranchIdToSalesCounter < ActiveRecord::Migration
  def change
    add_column :sales_counters, :branch_id, :integer
  end
end
