class RenamingContent < ActiveRecord::Migration

  def change
    rename_column :contents, :unitaire, :unitary
  end

end
