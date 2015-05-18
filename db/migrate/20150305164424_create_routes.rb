class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :title
      t.string :desc
      t.boolean :public

      t.timestamps null: false
    end
    add_reference :routes, :trip, index: true
  end
end
