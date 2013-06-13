class Addcolumnshortname < ActiveRecord::Migration

  def change
    add_column :registration_statuses, :short_name, :string
  end

end
