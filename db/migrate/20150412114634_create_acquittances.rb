class CreateAcquittances < ActiveRecord::Migration
  def change
    create_table :acquittances do |t|
      t.integer :sale_id
      t.string :no_reference
      t.string :method_of_payment

      t.timestamps null: false
    end
  end
end
