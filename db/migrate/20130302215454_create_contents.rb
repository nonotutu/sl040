class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :article_id
      t.integer :contenant_id
      t.integer :quantity

      t.timestamps
    end
  end
end
