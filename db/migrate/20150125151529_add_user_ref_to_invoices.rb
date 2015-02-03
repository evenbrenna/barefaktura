class AddUserRefToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :user_ref, :string
  end
end
