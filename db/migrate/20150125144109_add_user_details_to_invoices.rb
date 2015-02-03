class AddUserDetailsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :user_name, :string
    add_column :invoices, :user_org_number, :string
    add_column :invoices, :user_email, :string
    add_column :invoices, :user_phone, :string
    add_column :invoices, :user_bank_swift, :string
    add_column :invoices, :user_bank_iban, :string
    add_column :invoices, :user_bank_name, :string
    add_column :invoices, :user_bank_account, :string
  end
end
