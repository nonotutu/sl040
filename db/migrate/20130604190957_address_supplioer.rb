class AddressSupplioer < ActiveRecord::Migration

  def change
  	add_column :suppliers, :address, :text
  end

end
