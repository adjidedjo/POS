class SalesOrderJde < ActiveRecord::Base
  establish_connection :jdeoracle
  self.table_name = "proddta.f4211" #sd

  scope :delivered, -> { where("sdnxtr like ? and sdlttr like ? and sddcto like ?", "580", "245", "%ST%") }

  def self.find_order_by_serial(serial)
    where("sdlotn = ?", serial)
  end

  def self.find_sales_transfer_to_showroom(date, showroom_id)
    where("sdaddj = ? and sdshan like ?", date_to_julian(date), showroom_id).delivered
  end

  def self.date_to_julian(date)
    1000*(date.year-1900)+date.yday
  end
end
