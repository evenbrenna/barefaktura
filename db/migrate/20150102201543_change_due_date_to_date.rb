class ChangeDueDateToDate < ActiveRecord::Migration
  def change
    change_column :invoices, :due_date, 'date USING CAST(due_date AS date)'
  end
end
