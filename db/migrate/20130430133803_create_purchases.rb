class CreatePurchases < ActiveRecord::Migration
  
  def change
  
    create_table :purchases do |t|
      
      t.integer :item_id
      t.string :number
      t.date :purchased_on
      t.text :comment

      t.timestamps
      
    end
    
  end
  
end
