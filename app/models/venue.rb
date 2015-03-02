class Venue < ActiveRecord::Base
  has_many :sales
  belongs_to :branch

  validates :venue_name, :city, :branch_id, :from_period, :to_period, presence: true
end
