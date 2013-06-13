class Multiplescontenants < ActiveRecord::Migration

  def change
    add_column :contenants, :quantity, :integer
  end

end
