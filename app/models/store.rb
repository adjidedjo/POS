class Store < ActiveRecord::Base
  has_many :sales
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants
  has_one :supervisor_exhibition, dependent: :destroy
  accepts_nested_attributes_for :supervisor_exhibition
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions
  has_many :exhibition_stock_items
  belongs_to :channel
  belongs_to :branch

  validates :nama, :kota, :from_period, :to_period, :branch_id, :stock_items, :channel_id, presence: true

  before_create do
    self.kode_customer = SecureRandom.hex.first(4).upcase
  end
end
