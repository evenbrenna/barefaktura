class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :phone, :string
    add_column :users, :org_number, :string
    add_column :users, :bank_account, :string
    add_column :users, :bank_swift, :string
    add_column :users, :bank_iban, :string
  end
end
