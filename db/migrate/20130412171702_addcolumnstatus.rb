class Addcolumnstatus < ActiveRecord::Migration
  
  def change
    add_column :registrations, :status_id, :integer
  end

end
