class Branch < ActiveRecord::Base
  has_many :stores
  has_many :showrooms
  has_many :sales
  has_many :users
  has_many :sales_counters
end
