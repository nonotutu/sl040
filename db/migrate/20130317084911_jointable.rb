class Jointable < ActiveRecord::Migration
  
  def change
    create_table :departments_volunteers, :id => false do |t|
      t.integer :department_id, :null => false
      t.integer :volunteer_id, :null => false
    end
  end


end
