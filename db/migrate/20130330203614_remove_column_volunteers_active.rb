class RemoveColumnVolunteersActive < ActiveRecord::Migration

  def change
    remove_column :volunteers, :active
  end

end
