class SqlItemMaster < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :sqlserver
  self.table_name = "TbCabBarang"
end
