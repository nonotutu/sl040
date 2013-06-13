class Colors < ActiveRecord::Migration
  
  def change
    create_table :colors do |t|
      t.string :name
      t.string :hex

      t.timestamps
    end
    
    rename_column :departments, :color, :color_id

  end

end
