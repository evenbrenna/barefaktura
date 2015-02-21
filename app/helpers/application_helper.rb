# Helper methods needed in multiple resource views
module ApplicationHelper
  # returns total amount for overdue invoices for current user
  def overdue_amount
    amount = 0.00
    current_user.invoices.overdue.each do |i|
      amount += i.total
    end
    amount
  end

  # returns sum of unpaid invoices
  def unpaid_amount
    amount = 0.00
    current_user.invoices.unpaid.each do |i|
      amount += i.total
    end
    amount
  end
end
