class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :nature
      t.string :produit
      t.string :condition

      t.timestamps
    end
  end
end
