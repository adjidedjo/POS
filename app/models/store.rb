class Store < ActiveRecord::Base
  has_many :sales
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants
  belongs_to :channel
  belongs_to :branch

  before_create do
    self.kode_customer = SecureRandom.hex.first(4).upcase
  end
end
