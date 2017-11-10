class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.text :desc
      t.integer :rating

      t.timestamps
    end
  end
end
