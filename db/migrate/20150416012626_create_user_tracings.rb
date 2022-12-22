class CreateUserTracings < ActiveRecord::Migration
  def change
    create_table :user_tracings do |t|
      t.integer :user_id
      t.boolean :action
      t.string :ip

      t.timestamps null: false
    end
  end
end
