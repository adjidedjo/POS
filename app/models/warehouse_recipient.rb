class WarehouseRecipient < ActiveRecord::Base
  belongs_to :warehouse_admin
  belongs_to :channel_customer
end