class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :department_id
      t.datetime :rdv_at
      t.string :rdv_place

      t.timestamps
    end
  end
end
