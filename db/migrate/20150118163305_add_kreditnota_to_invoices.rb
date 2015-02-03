class AddKreditnotaToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :kreditnota, :boolean, :default => false
  end
end
