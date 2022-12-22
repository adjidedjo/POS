class AddKodeShowroomToChannelCustomers < ActiveRecord::Migration
  def change
    add_column :channel_customers, :kode_showroom, :string
  end
end
