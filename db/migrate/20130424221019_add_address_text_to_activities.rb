class AddAddressTextToActivities < ActiveRecord::Migration
  
  def change
    add_column :activities, :address, :text
  end
  
end
