class AddAddress < ActiveRecord::Migration

  def change
    add_column :volunteers, :address, :text
  end

end
