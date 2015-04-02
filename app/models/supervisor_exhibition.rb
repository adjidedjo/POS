class SupervisorExhibition < ActiveRecord::Base
  has_many :sales
  has_one :user, dependent: :destroy
  belongs_to :store
  belongs_to :channel_customer

  before_create do
    self.nama = nama.downcase
    regexp = '*54321'
    self.regex = regexp
    if email.nil?
      self.email = nama.downcase.slice(0..2)+'@ras.co.id'
    end
  end
end