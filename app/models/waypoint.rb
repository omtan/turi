class Waypoint < ActiveRecord::Base

  belongs_to :route
  validates :lat, presence: true
  validates :lng, presence: true

end
