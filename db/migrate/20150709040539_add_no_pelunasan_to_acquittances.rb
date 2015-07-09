class AddNoPelunasanToAcquittances < ActiveRecord::Migration
  def change
    add_column :acquittances, :no_pelunasan, :string
  end
end
