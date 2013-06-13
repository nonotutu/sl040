class Addcolorstodep < ActiveRecord::Migration

  def change
    add_column :departments, :color, :string
  end

end
