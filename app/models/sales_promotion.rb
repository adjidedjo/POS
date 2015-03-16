class SalesPromotion < ActiveRecord::Base
  has_one :user, dependent: :destroy
  belongs_to :store

  before_create do
    if nama.present?
      regexp = SecureRandom.hex.first(5).upcase
      self.regex = regexp
      if email.empty?
        self.email = nama.gsub(' ','')+'@ras.co.id'
      end
    end
  end

  after_create do
    if self.nama.present?
      password = self.nama.slice(0..2)+self.regex
      User.create(email: self.email, password: password, sales_promotion_id: self.id, role: 'sales_promotion')
    end
  end
end