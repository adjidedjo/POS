class Channel < ActiveRecord::Base
  has_many :stores, dependent: :destroy
  has_many :sales, dependent: :destroy
end
