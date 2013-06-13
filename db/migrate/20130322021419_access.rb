class Access < ActiveRecord::Migration

  def change
    rename_column :users, :admin, :activities_access
    rename_column :users, :reader, :equipment_access
    rename_column :users, :volo, :staff_access
  end

end
