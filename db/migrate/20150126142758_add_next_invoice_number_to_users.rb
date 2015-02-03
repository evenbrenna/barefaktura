class AddNextInvoiceNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :next_invoice_number, :integer, :default => 1
  end
end
