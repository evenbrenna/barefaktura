module ApplicationHelper
  # returns number of overdue invoices for current_user
  def overdue_count
    current_user.invoices.overdue.unpaid.count
  end

  # returns total amount for overdue invoices for current user
  def overdue_amount
    amount = 0.00
    current_user.invoices.overdue.unpaid.each do |i|
      amount += i.total
    end
    amount
  end

  # returns number of unpaid invoices for current user
  def outstanding_count
    outstanding = current_user.invoices.select { |i| !i.paid } # Outstanding
    outstanding.count
  end

  # returns sum of unpaid invoices
  def outstanding_amount
    amount = 0.00
    outstanding = current_user.invoices.select { |i| !i.paid } # Outstanding
    outstanding.each do |i|
      amount += i.total
    end
    amount
  end
end
