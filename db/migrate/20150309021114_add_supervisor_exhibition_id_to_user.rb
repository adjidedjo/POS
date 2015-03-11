class AddSupervisorExhibitionIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :supervisor_exhibition_id, :integer
  end
end
