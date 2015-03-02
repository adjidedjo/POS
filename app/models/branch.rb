class Branch < ActiveRecord::Base
  has_many :stores
  has_many :showrooms
  has_many :sales
end
