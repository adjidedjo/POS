class AddShowroomIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :showroom_id, :integer
  end
end
