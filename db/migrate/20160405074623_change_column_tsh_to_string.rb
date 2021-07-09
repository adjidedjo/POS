class ChangeColumnTshToString < ActiveRecord::Migration
  def up
    change_column :transfer_items, :tsh, :string
  end

  def down
    change_column :transfer_items, :tsh, :integer
  end
end
