class Merchant < ActiveRecord::Base
  belongs_to :channel_customer
end
