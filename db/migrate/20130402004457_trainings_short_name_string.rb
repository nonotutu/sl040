class TrainingsShortNameString < ActiveRecord::Migration

  def change
    add_column :trainings, :short_name, :string
  end

end
