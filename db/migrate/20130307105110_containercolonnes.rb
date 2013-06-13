class Containercolonnes < ActiveRecord::Migration

  def change
    rename_column :containers, :name, :short_name
    add_column :containers, :long_name, :string
    add_column :containers, :model, :string
  end

end
