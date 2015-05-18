FactoryGirl.define do
  factory :route do
    title "My Title"
    desc "My description"

    trait :with_waypoint do
      before(:create) do |route|
        route.waypoints << FactoryGirl.create(:waypoint, route: route)
      end
    end
  end
end
