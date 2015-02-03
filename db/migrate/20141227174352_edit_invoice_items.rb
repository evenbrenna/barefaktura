class EditInvoiceItems < ActiveRecord::Migration
  def change
    change_column :invoice_items, :quantity, :decimal, :precision => 8, :scale => 2
    change_column :invoice_items, :unit_price, :decimal, :precision => 8, :scale => 2
    add_column :invoice_items, :unit, :string
    remove_column :invoice_items, :total, :decimal
  end
end
