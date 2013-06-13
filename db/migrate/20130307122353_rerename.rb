class Rerename < ActiveRecord::Migration

  def change
    rename_column :containers, :long_name, :name
  end

end
