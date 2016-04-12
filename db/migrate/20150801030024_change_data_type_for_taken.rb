class ChangeDataTypeForTaken < ActiveRecord::Migration
  def self.up
    change_table :sale_items do |t|
      t.change :taken, :boolean
      t.change :bonus, :boolean
    end
  end
end