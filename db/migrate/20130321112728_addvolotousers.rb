class Addvolotousers < ActiveRecord::Migration

  def change
    add_column :users, :volo, :boolean
  end

end
