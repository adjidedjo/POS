class ChannelCustomer < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user
  has_many :sales, dependent: :destroy
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions, reject_if: proc { |a| a['nama'].blank?}
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants, reject_if: proc { |a| a['no_merchant'].blank?}
  has_many :supervisor_exhibitions, dependent: :destroy
  accepts_nested_attributes_for :supervisor_exhibitions, reject_if: proc { |a| a['nama'].blank?}

  validates :nama, :channel_id, :alamat, :kota, presence: true

  after_create do
    get_email = (self.nama.partition(' ').first) + "@ras.co.id"
    new_password = (self.nama.partition(' ').first) + "*54321"
    user_hash = {
      email: get_email,
      password: new_password
    }
    user = User.where(email: get_email).first_or_create(user_hash)
    self.update_attributes!(user_id: user.id)
  end
end
