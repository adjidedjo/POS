class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :venue_name
      t.string :city
      t.integer :branch_id
      t.date :from_period
      t.date :to_period

      t.timestamps null: false
    end
  end
end
