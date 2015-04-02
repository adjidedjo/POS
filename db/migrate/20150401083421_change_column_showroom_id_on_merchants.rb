class ChangeColumnShowroomIdOnMerchants < ActiveRecord::Migration
  def change
    change_column :merchants, :store_id, :integer
    change_column :merchants, :showroom_id, :integer
  end
end
