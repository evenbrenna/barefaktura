class AddClientDetailsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :client_name, :string
    add_column :invoices, :client_address, :string
    add_column :invoices, :client_email, :string
    add_column :invoices, :client_org_nr, :string
    add_column :invoices, :client_ref, :string
  end
end
