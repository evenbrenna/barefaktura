class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.text :description
      t.decimal :quantity
      t.integer :vat
      t.integer :user_id
      t.integer :invoice_id
      t.decimal :unit_price
      t.decimal :total

      t.timestamps
    end
  end
end
