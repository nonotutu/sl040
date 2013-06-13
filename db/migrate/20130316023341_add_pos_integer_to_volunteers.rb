class AddPosIntegerToVolunteers < ActiveRecord::Migration
  def change
    add_column :volunteers, :pos, :integer
  end
end
