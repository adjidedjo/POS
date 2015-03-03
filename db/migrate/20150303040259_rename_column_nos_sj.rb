class RenameColumnNosSj < ActiveRecord::Migration
  def up
    rename_column :sale_items, :nos_sj, :no_sj
  end
  def down
    rename_column :sale_items, :no_sj, :nos_sj
  end
end
