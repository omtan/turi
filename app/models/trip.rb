class Trip < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  ActsAsTaggableOn.remove_unused_tags = true

  belongs_to :user
  has_many :trips, through: :participants
  has_many :participants, :dependent => :delete_all
  has_many :equipment_lists, :dependent => :delete_all
  has_many :api_access_tokens, :dependent => :delete_all
  has_many :events, :dependent => :delete_all
  has_many :articles, :dependent => :delete_all
  has_many :discussions, :dependent => :delete_all
  has_many :routes, :dependent => :delete_all

  validates_presence_of :title
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_save :geocode_loc

  scope :public_trips, ->  { where(public: true) }

  def geocode_loc
      start_coords = Geocoder.coordinates(self.start_loc)
      end_coords = Geocoder.coordinates(self.end_loc)

     if start_coords.blank?
        self.start_loc_latitude, self.start_loc_longitude = nil
     else 
        self.start_loc_latitude, self.start_loc_longitude = start_coords
     end

     if end_coords.blank?
         self.end_loc_latitude, self.end_loc_longitude = nil
     else
         self.end_loc_latitude, self.end_loc_longitude = end_coords
     end

  end

  def self.search(title_search, location_search, tag_search, date_beg, date_end)
    trips = []

    if title_search.present? || location_search.present?
      trips = Trip.where('title LIKE ? AND (start_loc LIKE ? OR end_loc LIKE ?)', "%#{title_search}%","%#{location_search}%", "%#{location_search}%")
    end

    if tag_search.present?
      ary_tag = tag_search.split
      #get_tagged = Trip.tagged_with(ary_tag, :on => :tags)
      if trips.blank?
        trips = Trip.tagged_with(ary_tag, :on => :tags)
      else
        trips = trips.tagged_with(ary_tag, :on => :tags)
      end
    end

    if date_beg.present? || date_end.present?
      #date_beg = date_end unless date_beg.present?
      #date_end = date_beg unless date_end.present?

      if trips.nil?
        trips = Trip.where('start_date >= ? AND end_date <= ?', date_beg, date_end)
      else
        trips = trips.where('start_date >= ? AND end_date <= ?', date_beg, date_end)
      end

    end

    return trips
  end

end
