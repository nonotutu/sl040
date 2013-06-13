class AddColumnItemsSupplierIdInteger < ActiveRecord::Migration

  def change
    add_column :items, :supplier_id, :integer
  end

end
