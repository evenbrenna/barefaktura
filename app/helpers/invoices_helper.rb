# Helper for invoice views
module InvoicesHelper
  # Returns a bootstrap label class based on count
  def overdue_label_color
    current_user.invoices.overdue.count == 0 ? 'label-success' : 'label-danger'
  end

  # returns total amount for overdue invoices for current user
  def overdue_amount
    amount = 0.00
    current_user.invoices.overdue.each do |i|
      amount += i.total
    end
    amount
  end

  # returns total amount and currency for invoices in given array
  def subtotal(invoices)
    amount = 0.00
    invoices.each do |i|
      if i.kreditnota
        amount -= i.total
      else
        amount += i.total
      end
    end
    number_to_currency(amount)
  end

  # returns sum of unpaid invoices
  def unpaid_amount
    amount = 0.00
    current_user.invoices.unpaid.each do |i|
      amount += i.total
    end
    amount
  end

  # To mark overdue invoices table row in red
  def rowcolor(invoice)
    if !invoice.paid && (DateTime.now.to_date > invoice.due_date)
      return 'danger'
    else
      ''
    end
  end

  # Calculates and returns 'momsgrunnlag' for the given invoice/percentage
  def finn_grunnlag(invoice, percent)
    items = []
    grunnlag = 0

    # Collect items with specified vat
    invoice.invoice_items.each do |item|
      items << item if (item.vat == percent)
    end

    # Sum price x quantity for all items
    items.each do |item|
      grunnlag += (item.unit_price * item.quantity)
    end
    grunnlag
  end

  # Returns true if the given invoice has items with multiple vat percentages
  def multiple_mva(invoice)
    satser = 0

    [0, 8, 15, 25].each do |vat|
      satser += 1 if finn_grunnlag(invoice, vat) > 0
    end
    satser > 1
  end
end
