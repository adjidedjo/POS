class AddSerialToAdjusments < ActiveRecord::Migration
  def change
    add_column :adjusments, :serial, :string
  end
end
