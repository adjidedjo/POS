class AddColumnSupervisorExhibitionIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :supervisor_exhibition_id, :integer
  end
end
