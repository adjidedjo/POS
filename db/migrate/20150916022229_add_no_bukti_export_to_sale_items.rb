class AddNoBuktiExportToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :no_bukti_exported, :string
  end
end
