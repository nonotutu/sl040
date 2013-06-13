class AddGoogleDrivePasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_drive_password, :string
  end
end
