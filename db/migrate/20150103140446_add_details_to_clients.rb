class AddDetailsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :org_nr, :string
    add_column :clients, :ref, :string
  end
end
