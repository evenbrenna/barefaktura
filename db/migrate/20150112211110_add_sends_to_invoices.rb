class AddSendsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :sends, :integer, :default => 0
  end
end
