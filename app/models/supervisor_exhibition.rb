class SupervisorExhibition < ActiveRecord::Base
  has_many :sales
  has_one :user, dependent: :destroy
  belongs_to :store

  before_create do
    self.nama = nama.downcase
    regexp = '*54321'
    self.regex = regexp
    if email.nil?
      self.email = nama.downcase.slice(0..2)+'@ras.co.id'
    end
  end

  after_create do
    password = self.nama.downcase.slice(0..2)+self.regex
    User.create(email: self.email, password: password, supervisor_exhibition_id: self.id, role: 'supervisor')
  end
end