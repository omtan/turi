class CreateWaypoints < ActiveRecord::Migration
  def change
    create_table :waypoints do |t|
      t.string :desc
      t.decimal :lat
      t.decimal :lng
      t.string :typ

      t.timestamps null: false
    end

    add_reference :waypoints, :route, index: true
  end
end
