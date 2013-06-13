class AddVolunteersActiveBoolean < ActiveRecord::Migration

  def change
    add_column :volunteers, :active, :boolean
  end

end
