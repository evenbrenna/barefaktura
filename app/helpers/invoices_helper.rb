module InvoicesHelper
  # To mark overdue invoices table row in red
  def rowcolor(invoice)
    if !invoice.paid && (DateTime.now.to_date > invoice.due_date)
      return 'danger'
    else
      ''
    end
  end

  # Calculates and returns 'momsgrunnlag' for
  # the given invoice and vat percentage
  def finn_grunnlag(invoice, percent)
    items = []
    grunnlag = 0

    invoice.invoice_items.each do |item|
      items << item if (item.vat == percent)
    end

    items.each do |item|
      grunnlag += (item.unit_price * item.quantity)
    end
    grunnlag
  end

  # Returns true if the given invoice has items
  # with multiple vat percentages
  def multiple_mva(invoice)
    satser = 0
    if finn_grunnlag(invoice, 25) > 0
      satser += 1
    end

    if finn_grunnlag(invoice, 15) > 0
      satser += 1
    end

    if finn_grunnlag(invoice, 8) > 0
      satser += 1
    end

    if finn_grunnlag(invoice, 0) > 0
      satser += 1
    end
    satser > 1
  end
end
