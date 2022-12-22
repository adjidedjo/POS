class AddNoSjToAdjusments < ActiveRecord::Migration
  def change
    add_column :adjusments, :no_sj, :string
  end
end
