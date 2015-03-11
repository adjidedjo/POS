class CreateSupervisorExhibitions < ActiveRecord::Migration
  def change
    create_table :supervisor_exhibitions do |t|
      t.string :nama
      t.string :email
      t.string :nik
      t.integer :user_id
      t.integer :store_id

      t.timestamps null: false
    end
  end
end
