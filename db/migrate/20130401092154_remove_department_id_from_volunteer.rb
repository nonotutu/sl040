class RemoveDepartmentIdFromVolunteer < ActiveRecord::Migration

  def change
    remove_column :volunteers, :department_id
  end

end
