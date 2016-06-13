class WarehouseAdmin < ActiveRecord::Base
  has_many :warehouse_recipients
  belongs_to :branch
end
