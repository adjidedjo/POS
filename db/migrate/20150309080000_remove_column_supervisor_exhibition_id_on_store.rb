class RemoveColumnSupervisorExhibitionIdOnStore < ActiveRecord::Migration
  def change
    remove_column :stores, :supervisor_exhibition_id
  end
end
