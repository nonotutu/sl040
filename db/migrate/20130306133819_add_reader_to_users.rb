class AddReaderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reader, :boolean
  end
end
