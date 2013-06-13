class CreateActNeeds < ActiveRecord::Migration
  def change
    create_table :act_needs do |t|
      t.integer :pos
      t.string :name
      t.integer :activity_id
      t.integer :qty_volunteers

      t.timestamps
    end
  end
end
