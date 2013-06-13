class RenameColumnContents < ActiveRecord::Migration

  def change
    rename_column :contents, :article_id, :item_id
  end

end
