module ApplicationHelper

    # returns number of overdue invoices for current_user
    def overdue_count
        overdue = current_user.invoices.select{ |i| !i.paid && (DateTime.now.to_date > i.due_date)} #Overdue
        overdue.count
    end

    # returns total amount for overdue invoices for current user
    def overdue_amount
        amount = 0.00
        overdue = current_user.invoices.select{ |i| !i.paid && (DateTime.now.to_date > i.due_date)} #Overdue
        overdue.each do |i|
            amount += i.total
        end
        amount
    end

    # returns number of unpaid invoices for current user
    def outstanding_count
        outstanding = current_user.invoices.select{ |i| !i.paid } #Outstanding
        outstanding.count
    end

    # returns sum of unpaid invoices
    def outstanding_amount
        amount = 0.00
        outstanding = current_user.invoices.select{ |i| !i.paid } #Outstanding
        outstanding.each do |i|
            amount += i.total
        end
        amount
    end

end
