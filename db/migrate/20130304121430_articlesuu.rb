class Articlesuu < ActiveRecord::Migration

  def change
    add_column :articles, :uu, :boolean
  end

end
