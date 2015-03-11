class RenameColumnStoreIdInStore < ActiveRecord::Migration
  def change
    rename_column :stores, :store_id, :supervisor_exhibition_id
  end
end
