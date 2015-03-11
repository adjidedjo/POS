class SupervisorExhibition < ActiveRecord::Base

  validates :nama, :email, :nik, presence: true
  has_many :sales
  has_one :user, dependent: :destroy
  belongs_to :store

  before_create do
    regexp = SecureRandom.hex.first(5).upcase
    self.regex = regexp
    if email.nil?
      self.email = nama.slice(0..2)+'@ras.co.id'
    end
  end

  after_create do
    password = self.nama.slice(0..2)+self.regex
    User.create(email: self.email, password: password, supervisor_exhibition_id: self.id, role: 'supervisor')
  end
end