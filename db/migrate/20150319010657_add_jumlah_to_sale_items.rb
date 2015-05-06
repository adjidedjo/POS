class AddJumlahToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :jumlah, :integer
  end
end
