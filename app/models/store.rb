class Store < ActiveRecord::Base
  has_many :sales
  belongs_to :channel
  belongs_to :branch

  before_create do
    self.kode_customer = SecureRandom.hex.first(4).upcase
  end
end
