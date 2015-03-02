class Showroom < ActiveRecord::Base
  has_many :sales
  belongs_to :branch

  validates :name, :branch_id, :city, presence: true
end
