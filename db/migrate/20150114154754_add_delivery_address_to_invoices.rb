class AddDeliveryAddressToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :delivery_address, :string
  end
end
