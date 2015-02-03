class AddIndexesToUser < ActiveRecord::Migration
  def change
    add_index :invoices, :user_id
    add_index :invoices, :client_id
    add_index :products, :user_id
    add_index :clients, :user_id
    add_index :invoice_items, :user_id
    add_index :invoice_items, :invoice_id
  end
end
