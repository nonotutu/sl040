class Addcolumnactneddidregistration < ActiveRecord::Migration

  def change
    add_column :registrations, :act_need_id, :integer
  end

end
