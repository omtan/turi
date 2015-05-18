class WaypointsController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])

    @waypoint = Waypoint.new

  end


  def create
    @trip = Trip.find(params[:trip_id])

    @waypoint = Route.new(params[:trip_id, :route_id]).waypoints

    if @route.update_attribute(params[:trip_id, :route_id])
      return redirect_to root_url
    else
      render :action => :new
    end
  end
end
