class CreateShowrooms < ActiveRecord::Migration
  def change
    create_table :showrooms do |t|
      t.string :name
      t.integer :branch_id
      t.string :city

      t.timestamps null: false
    end
  end
end
