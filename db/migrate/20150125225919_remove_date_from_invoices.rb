class RemoveDateFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :date, :date
  end
end
