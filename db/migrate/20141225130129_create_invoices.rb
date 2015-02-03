class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :client_id
      t.integer :invoice_number
      t.date :order_date
      t.date :delivery_date
      t.hstore :items, array: true
      t.decimal :total
      t.string :currency
      t.text :notes
      t.date :invoice_date, :date
      t.date :due_date, :date

      t.timestamps
    end
  end
end
