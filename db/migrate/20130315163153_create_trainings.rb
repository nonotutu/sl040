class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
