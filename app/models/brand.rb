class Brand < ActiveRecord::Base
  has_many :netto_sale_brands
  has_many :sales, through: :netto_sale_brands
end
