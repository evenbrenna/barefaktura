class RemoveFieldsFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :items, :hstore
    remove_column :invoices, :invoice_date, :date
  end
end
