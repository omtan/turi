module TripResourceHelper

  def fetch_upcoming_events(trip)
    trip.events.where('start_date > ?', DateTime.now).order(:start_date).limit(5)
  end

  def fetch_recent_discussions(trip)
    trip.discussions.order(:updated_at).limit(5)
  end

end
