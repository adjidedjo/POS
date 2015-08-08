class AddNoOrderToAquittances < ActiveRecord::Migration
  def change
    add_column :acquittances, :no_order, :string
  end
end
