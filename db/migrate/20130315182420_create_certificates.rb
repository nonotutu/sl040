class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.integer :volunteer_id
      t.integer :training_id
      t.string :number
      t.date :issued_on

      t.timestamps
    end
  end
end
