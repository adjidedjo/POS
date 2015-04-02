class AddShowroomIdToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :showroom_id, :integer
  end
end
