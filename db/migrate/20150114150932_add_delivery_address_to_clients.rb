class AddDeliveryAddressToClients < ActiveRecord::Migration
  def change
    add_column :clients, :delivery_address, :string
  end
end
