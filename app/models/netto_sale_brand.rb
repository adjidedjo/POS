class NettoSaleBrand < ActiveRecord::Base
  belongs_to :brand
  belongs_to :sale

end
