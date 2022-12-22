class SqlSales < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :sqlserver
  # self.table_name = "tbCabPacklistDetBackup"
  self.table_name = "tbCabPacklistDet"
end