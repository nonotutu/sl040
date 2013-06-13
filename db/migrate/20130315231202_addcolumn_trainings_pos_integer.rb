class AddcolumnTrainingsPosInteger < ActiveRecord::Migration

  def change
    add_column :trainings, :pos, :integer
  end

end
