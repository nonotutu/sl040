class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end
