class Store < ActiveRecord::Base
  has_many :sales
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants
  has_one :supervisor_exhibition, dependent: :destroy
  accepts_nested_attributes_for :supervisor_exhibition
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions
  belongs_to :channel
  belongs_to :branch

  before_create do
    self.kode_customer = SecureRandom.hex.first(4).upcase
  end
end
