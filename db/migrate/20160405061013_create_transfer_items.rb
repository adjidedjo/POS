class CreateTransferItems < ActiveRecord::Migration
  def change
    create_table :transfer_items do |t|
      t.string :tfnmr
      t.string :brg
      t.string :nbrg
      t.integer :jml
      t.integer :ash
      t.integer :tsh

      t.timestamps null: false
    end
  end
end
