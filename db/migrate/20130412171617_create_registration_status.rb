class CreateRegistrationStatus < ActiveRecord::Migration
  def change
    create_table :registration_statuses do |t|
      t.integer :pos
      t.string :name

      t.timestamps
    end
  end
end
