class Route < ActiveRecord::Base


  belongs_to :trip
  validates :title, presence: true
  validates :desc, presence: true

  has_many :waypoints, :dependent => :delete_all

  accepts_nested_attributes_for :waypoints

  validate :must_have_one_waypoint

  def must_have_one_waypoint
    errors.add(:waypoints, 'must have one waypoint') if waypoints_empty?
  end

  def waypoints_empty?
    waypoints.empty? or waypoints.all? {|waypoint| waypoint.marked_for_destruction? }
  end


end
