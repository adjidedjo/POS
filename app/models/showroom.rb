class Showroom < ActiveRecord::Base
  has_many :sales
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions, reject_if: proc { |a| a['nama'].blank?}
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants, reject_if: proc { |a| a['no_merchant'].blank?}
  belongs_to :user
  belongs_to :branch
  belongs_to :channel

  validates :name, :branch_id, :city, presence: true

  before_create do
    remove_showroom = name.gsub(/showroom /, '').downcase
    self.name = remove_showroom
    self.city = city.downcase
  end

  after_create do
    get_email = (self.name.partition(' ').first) + "@ras.co.id"
    password_showroom = (self.name.partition(' ').first) + "*54321"
    user_hash = {
      email: get_email,
      password: password_showroom,
      role: "showroom",
      nama: self.name
    }
    user = User.where(email: get_email, showroom_id: self.id).first_or_create(user_hash)
    self.update_attributes!(user_id: user.id)
  end
end
