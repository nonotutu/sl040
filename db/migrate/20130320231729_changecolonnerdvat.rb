class Changecolonnerdvat < ActiveRecord::Migration

  def change
    rename_column :activities, :rdv_at, :rendezvous_at
    rename_column :activities, :rdv_place, :rendezvous_place
  end

end
