class JdeItemMaster < ActiveRecord::Base
  establish_connection :jdeoracle
  self.table_name = "proddta.f4101" #im

  def self.find_item_number(item)
    item_number = where("imitm like ?", "#{item}%")
    item_number.empty? ? 0 : item_number.first.imaitm
  end

  def self.find_item_desc1(item)
    item_number = where("imaitm like ?", "#{item}%")
    item_number.empty? ? 0 : item_number.first.imdsc1
  end

  def self.find_item_desc2(item)
    item_number = where("imaitm like ?", "#{item}%")
    item_number.empty? ? 0 : item_number.first.imdsc2
  end
end