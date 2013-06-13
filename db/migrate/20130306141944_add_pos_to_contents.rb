class AddPosToContents < ActiveRecord::Migration
  def change
    add_column :contents, :pos, :integer
  end
end
