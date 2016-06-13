class AddExportedToAcquittance < ActiveRecord::Migration
  def change
    add_column :acquittances, :exported, :boolean, :default => 0
    add_column :acquittances, :exported_at, :datetime
    add_column :acquittances, :exported_by, :integer
  end
end
