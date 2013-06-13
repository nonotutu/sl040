class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.string :cr_number
      t.integer :sex
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :email
      t.string :land_phone
      t.string :cell_phone
      t.date :cr_joined_on

      t.timestamps
    end
  end
end
