class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :description
      t.string :unit
      t.decimal :price
      t.integer :vat
      t.integer :user_id
      t.string :product_number

      t.timestamps null: false
    end
  end
end
