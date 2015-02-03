class AddUserAddressToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :user_address, :string
  end
end
