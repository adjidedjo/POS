class JdeItemAvailability < ActiveRecord::Base
  establish_connection :jdeoracle
  self.table_name = "proddta.f41021" #li


  def self.available
    where("limcu like ? and lipqoh >= ?", "%11011", 1)
  end

  def self.find_serial(serial)
    where("lilotn like ?", "#{serial}%")
  end

  def self.find_item_master(code)
    JdeItemMaster.find_item_number(code)
  end
end
