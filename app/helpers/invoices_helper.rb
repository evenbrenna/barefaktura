module InvoicesHelper

    # td class in index view
    def rowcolor(invoice)
        if !invoice.paid && (DateTime.now.to_date > invoice.due_date)
            return 'danger'
        else
            ''
        end
    end

    # momsspesifisering
    def finn_grunnlag(invoice, percent)
        items = []
        grunnlag = 0

        # hent alle med 25%
        invoice.invoice_items.each do |item|
            if item.vat == percent
                items << item
            end
        end

        # summer
        items.each do |item|
            grunnlag += (item.unit_price * item.quantity)
        end

        grunnlag
    end

    def multiple_mva(invoice)
        satser = 0
        if (finn_grunnlag(invoice, 25) > 0)
            satser += 1
        end

        if (finn_grunnlag(invoice, 15) > 0)
            satser += 1
        end

        if (finn_grunnlag(invoice, 8) > 0)
            satser += 1
        end

        if (finn_grunnlag(invoice, 0) > 0)
            satser += 1
        end

        satser > 1
    end
end
