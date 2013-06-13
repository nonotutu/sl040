class RenameColumns < ActiveRecord::Migration

  def change
    rename_column :containers, :contenant_id, :container_id
    rename_column :contents, :contenant_id, :container_id
  end

end
