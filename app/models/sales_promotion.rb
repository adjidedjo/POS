class SalesPromotion < ActiveRecord::Base

  validates :nama, :nik, presence: true
  has_one :user, dependent: :destroy
  belongs_to :store

  before_create do
    regexp = SecureRandom.hex.first(5).upcase
    self.regex = regexp
    if email.empty?
      self.email = nama.gsub(' ','')+'@ras.co.id'
    end
  end

  after_create do
    password = self.nama.slice(0..2)+self.regex
    User.create(email: self.email, password: password, sales_promotion_id: self.id, role: 'sales_promotion')
  end
end