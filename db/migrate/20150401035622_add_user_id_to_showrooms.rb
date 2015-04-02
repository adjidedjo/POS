class AddUserIdToShowrooms < ActiveRecord::Migration
  def change
    add_column :showrooms, :user_id, :integer
  end
end
