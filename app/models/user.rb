class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :registerable

  has_many :sales
  has_many :sale_items
  has_one :showroom
  has_one :channel_customer
  belongs_to :supervisor_exhibition
  belongs_to :sales_promotion
  belongs_to :store

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_create do
    self.role = 'admin' if admin?
  end
end
