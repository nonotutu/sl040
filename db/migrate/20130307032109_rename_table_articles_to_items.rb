class RenameTableArticlesToItems < ActiveRecord::Migration

  def change
    rename_table :articles, :items
  end

end
