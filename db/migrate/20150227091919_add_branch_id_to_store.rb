class AddBranchIdToStore < ActiveRecord::Migration
  def change
    add_column :stores, :branch_id, :integer
  end
end
