class SetInvoicesPaidToFalseByDefault < ActiveRecord::Migration
  def change
    change_column :invoices, :paid, :boolean, :default => false
  end
end
