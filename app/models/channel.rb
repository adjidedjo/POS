class Channel < ActiveRecord::Base
  has_many :stores, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :showrooms, dependent: :destroy
  has_many :channel_customers, dependent: :destroy
end
