class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :sales
  has_many :sale_items
  belongs_to :supervisor_exhibition
  belongs_to :sales_promotion

  before_create do
    self.role = 'admin' if admin?
  end
end
