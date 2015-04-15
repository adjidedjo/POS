class Recipient < ActiveRecord::Base
  belongs_to :sales_counter
  belongs_to :channel_customer
  belongs_to :brand
end
