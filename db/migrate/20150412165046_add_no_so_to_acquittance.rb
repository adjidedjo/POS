class AddNoSoToAcquittance < ActiveRecord::Migration
  def change
    add_column :acquittances, :no_so, :string
  end
end
