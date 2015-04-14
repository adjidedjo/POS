class ChannelCustomer < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user
  has_many :acquittances, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :sales_promotions, dependent: :destroy
  accepts_nested_attributes_for :sales_promotions, allow_destroy: true, reject_if: proc { |a| a['nama'].blank?}
  has_many :merchants, dependent: :destroy
  accepts_nested_attributes_for :merchants, allow_destroy: true, reject_if: proc { |a| a['no_merchant'].blank?}
  has_many :supervisor_exhibitions, dependent: :destroy
  accepts_nested_attributes_for :supervisor_exhibitions, allow_destroy: true, reject_if: proc { |a| a['nama'].blank?}

  validates :nama, :channel_id, :alamat, :kota, presence: true

  before_create do
    up_nama = nama.upcase
    if up_nama.include?("SHOWROOM") or up_nama.include?("PAMERAN")
      get_word = up_nama.partition(' ').first
      self.nama = up_nama.gsub(get_word,'').strip.downcase
    end
  end

  after_create do
    get_email = (self.nama.partition(' ').first) + "@ras.co.id"
    new_password = (self.nama.partition(' ').first) + "*54321"
    new_username = (self.channel.kode.downcase+self.nama.partition(' ').first)
    user_hash = {
      email: get_email,
      password: new_password,
      username: new_username
    }
    user = User.where(email: get_email).first_or_create(user_hash)
    self.update_attributes!(user_id: user.id)
  end
end
