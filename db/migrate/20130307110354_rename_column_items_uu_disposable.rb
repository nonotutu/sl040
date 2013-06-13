class RenameColumnItemsUuDisposable < ActiveRecord::Migration

  def change
    rename_column :items, :uu, :disposable
  end

end
