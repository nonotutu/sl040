class AddcolumnContainersStatusInteger < ActiveRecord::Migration

  def change
    add_column :containers, :status, :integer
  end

end
