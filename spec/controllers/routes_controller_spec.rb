require 'rails_helper'

RSpec.describe RoutesController, type: :controller do

  before do
    #@owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    #@participant = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)


    #FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)

    sign_in(@editor)

    # set HTTP_REFERER to root_path, to make :back redirects to work
    request.env['HTTP_REFERER'] = root_path

  end

  describe "GET #index" do
    it "render the template" do
      get :index, :trip_id => @trip.id
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "render the template" do
      get :new, trip_id: @trip.id
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do

    it "Create a valid Route" do

      rout = FactoryGirl.attributes_for(:route).merge(waypoints_attributes: [FactoryGirl.attributes_for(:waypoint)])
      expect {
        post :create, route: rout, trip_id: @trip.id
      }.to change(Route, :count).by(1)
      #expect(response).to redirect_to @trip  # FIXME How to redirect? Should redirect to ..trips/1/routes/1
      expect(flash[:notice]).to eq(I18n.t 'trip_route_added')
    end

    it "Create a valid route, for a non existing trip" do
      post :create, :trip_id => 999, :route => FactoryGirl.attributes_for(:route, :trip_id => 999)
      expect(flash[:alert]).to eq(I18n.t 'trip_not_found')
      expect(response).to redirect_to dashboard_path
    end

    it "Render the form again, if something went wrong" do
      post :create, :trip_id => @trip.id, route: FactoryGirl.attributes_for(:route, :name => nil)
      expect(flash[:alert]).to eq(I18n.t 'trip_route_not_added')
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    it "Render and assign the #show" do
      @route = FactoryGirl.create(:route, :with_waypoint)
      get :show, :trip_id => @trip.id, :id => @route.id
      expect(assigns(:route)).to eq(@route)
      expect(response).to render_template :show
    end

    it "Get a invalid route" do
      get :show, :trip_id => @trip.id, :id => 999
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t 'trip_route_not_found')
    end
  end

  describe "PUT #edit" do
    before do
      @route = FactoryGirl.create(:route, :with_waypoint)
    end

    it "locate the requested route and redirect to the @route" do
      put :update, :id => @route.id, :route => FactoryGirl.attributes_for(:route), :trip_id => @trip.id
      expect(assigns(:route)).to eq(@route)
      expect(flash[:notice]).to eq(I18n.t 'trip_route_updated')
    end

    it "change the @route's attributes" do
      put :update, :trip_id => @trip.id, :id => @route.id, :route => FactoryGirl.attributes_for(:route, :title => "Some title", :desc => "Some description")
      @route.reload
      expect(@route.title).to eq("Some title")
      expect(@route.desc).to eq("Some description")
    end

    it "invalid/missing attributes" do
      put :update, :trip_id => @trip.id, :id => @route.id, :route => FactoryGirl.attributes_for(:route, :title => nil, :desc => "Some description")
      @route.reload
      expect(@route.desc).not_to eq("Some description")
      expect(flash[:alert]).to eq(I18n.t 'trip_route_not_updated')
    end

    it "Get a invalid route" do
      get :update, :trip_id => @trip.id, :id => 999
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t 'trip_route_not_found')
    end

  end

  describe "DELETE #delete" do
    before do
      @route = FactoryGirl.create(:route, :with_waypoint)
    end

    it "Deletes the route" do
      expect { delete :destroy, :trip_id => @trip.id, :id => @route.id }.to change(Route, :count).by(-1)
      expect(response).to redirect_to trip_routes_path(@trip.id)
      expect(flash[:notice]).to eq(I18n.t 'trip_route_deleted')
    end
  end
end
