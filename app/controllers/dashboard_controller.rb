class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @trips = Kaminari.paginate_array(current_user.trips).page(params[:page]).per(6)
  end

end
