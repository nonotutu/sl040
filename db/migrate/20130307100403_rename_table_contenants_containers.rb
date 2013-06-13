class RenameTableContenantsContainers < ActiveRecord::Migration

  def change
    rename_table :contenants, :containers
  end

end
