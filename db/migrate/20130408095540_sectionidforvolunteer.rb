class Sectionidforvolunteer < ActiveRecord::Migration

  def change
    add_column :volunteers, :section_id, :integer
  end

end
