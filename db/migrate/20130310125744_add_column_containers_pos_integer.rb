class AddColumnContainersPosInteger < ActiveRecord::Migration
  
  def change
    add_column :containers, :pos, :integer
  end

end
