class SalesCounter < ActiveRecord::Base
  has_many :recipients
  belongs_to :branch
end
