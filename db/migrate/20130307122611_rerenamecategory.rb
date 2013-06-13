class Rerenamecategory < ActiveRecord::Migration

  def change
    rename_column :categories, :long_name, :name
  end

end
