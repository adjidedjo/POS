class AddBranchIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :branch_id, :integer, :default => 0
  end
end
