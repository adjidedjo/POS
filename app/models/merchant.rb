class Merchant < ActiveRecord::Base

  validates :nama, :no_merchant, presence: true
  belongs_to :store
end
