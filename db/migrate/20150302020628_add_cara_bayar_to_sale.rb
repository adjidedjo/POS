class AddCaraBayarToSale < ActiveRecord::Migration
  def change
    add_column :sales, :cara_bayar, :string
  end
end
