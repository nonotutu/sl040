class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :volunteer_id
      t.integer :activity_id
      t.integer :starts_delay
      t.integer :ends_delay
      t.string :rendezvous_place

      t.timestamps
    end
  end
end
