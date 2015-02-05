class InvoicesController < ApplicationController

    before_action :authenticate_user!

    def index
        @user = current_user
        @invoices = current_user.invoices.all.except(:order).order('invoice_number DESC')
    end

    def new
        @user = current_user
        @invoice = current_user.invoices.new
        @client_list = current_user.clients.map { |c| [c.name, c.id] }
        @invoice.invoice_items.build
        @products = current_user.products.all

        @invoice.invoice_number = @user.next_invoice_number
    end

    def create
        @user = current_user
        @invoice = current_user.invoices.new(invoice_params)
        @client_list = current_user.clients.map { |c| [c.name, c.id] }
        @products = current_user.products.all

        @invoice.assign_attributes(:user_name => @user.name,
                                    :user_org_number => ((@user.foretaks_reg ? 'Foretaksregisteret ' : 'Org.nr: ') + (@user.org_number) + (@user.mva_reg ? ' MVA' : '')),
                                    :user_email => @user.email,
                                    :user_phone => @user.phone,
                                    :user_bank_swift => @user.bank_swift,
                                    :user_bank_iban => @user.bank_iban,
                                    :user_bank_name => @user.bank_name,
                                    :user_bank_account => @user.bank_account,
                                    :user_address => @user.address)

        if @invoice.client_id.blank?
            new_client = current_user.clients.new(:name => @invoice.client_name,
                                                    :email => @invoice.client_email,
                                                    :address => @invoice.client_address,
                                                    :delivery_address => @invoice.delivery_address,
                                                    :ref => @invoice.client_ref,
                                                    :org_nr => @invoice.client_org_nr)

            if @invoice.valid?
                if new_client.save
                    flash[:notice] = 'Ny kunde er opprettet!'
                    @invoice.assign_attributes(:client_id => new_client.id)
                end
            end

        end

        # save like usual
        if @invoice.save
                @user.update_attribute(:next_invoice_number, (@user.next_invoice_number + 1))
                redirect_to invoices_path, :notice => "Faktura er opprettet!"
        else
            render "new"
        end

    end

    def show
        @invoice = current_user.invoices.find(params[:id])

        respond_to do |format|
            format.html
            format.pdf do
                render :pdf => "faktura_#{@invoice.invoice_number}",
                :disposition => "attachment",
                #:print_media_type => true,
                :encoding => 'utf8'
            end
        end
    end

    def email_invoice
        @user = current_user
        @invoice = current_user.invoices.find(params[:id])
        @client = @invoice.client
        @type = @invoice.kreditnota ? 'kreditnota' : 'faktura'

        # Unødvendig??
        # respond_to do |format|
        #     format.html
        #     format.js
        # end

    end

    def send_email_invoice
        @invoice = current_user.invoices.find(params[:id])
        message = params[:message]

        UserMailer.pdf_email(@invoice, message).deliver_now
        @invoice.update_attribute(:sends, @invoice.sends + 1)
        redirect_to invoices_path
        flash[:notice] = 'Faktura er sendt til kunde. Kopi er sendt til din epost. Levering kan ta noen minutter.'
    end

    def set_paid
        @invoice = Invoice.find(params[:id])
        @invoice.update_column :paid, params[:paid]

        redirect_to(:back)
    end

    def kreditnota
        @user = current_user
        @invoice_to_credit = current_user.invoices.find(params[:id])
        @invoice = @invoice_to_credit.replicate
        @invoice.assign_attributes(:notes => "Kreditnota for faktura #{@invoice_to_credit.invoice_number.to_s}", :kreditnota => true)

        @client_list = current_user.clients.map { |c| [c.name, c.id] }
        @products = current_user.products.all

        @invoice.invoice_number = current_user.next_invoice_number

    end

    private

        def invoice_params
            params.require(:invoice).permit(:notes, :client_id,
                                            :user_name,
                                            :user_org_number,
                                            :user_email,
                                            :user_phone,
                                            :user_bank_swift,
                                            :user_bank_iban,
                                            :user_bank_name,
                                            :user_bank_account,
                                            :user_address,
                                            :user_ref,
                                            :invoice_number,
                                            :kreditnota,
                                            :due_date,
                                            :order_date,
                                            :delivery_date,
                                            :total,
                                            :currency,
                                            :paid,
                                            :client_name,
                                            :client_email,
                                            :client_address,
                                            :delivery_address,
                                            :client_ref,
                                            :client_org_nr,
                                            invoice_items_attributes: [:id, :description, :quantity, :vat, :unit, :unit_price, :total, :user_id, :invoice_id, :_destroy])
        end
end
