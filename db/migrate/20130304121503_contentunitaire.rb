class Contentunitaire < ActiveRecord::Migration

  def change
    add_column :contents, :unitaire, :boolean
  end

end
