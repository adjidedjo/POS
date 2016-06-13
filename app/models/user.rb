class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :registerable,:trackable

  has_many :user_tracings
  has_many :sales
  has_many :sale_items
  has_one :showroom
  has_one :channel_customer
  belongs_to :supervisor_exhibition
  belongs_to :sales_promotion
  belongs_to :store
  belongs_to :branch

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_create do
    self.role = 'admin' if admin?
    old_signin = self.last_sign_in_at
    if self.last_sign_in_at != old_signin
      UserTracing.create :user_id => self.id, :action => "login", :ip => self.last_sign_in_ip
    end
  end

  def update_tracked_fields!(request)
    old_signin = self.last_sign_in_at
    super
    if self.last_sign_in_at != old_signin
      UserTracing.create :user_id => self.id, :action => 1, :ip => self.last_sign_in_ip
    end
  end
end
