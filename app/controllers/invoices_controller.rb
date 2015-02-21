class InvoicesController < ApplicationController
  # Authenticate with Devise, Authorize with CanCanCan
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @invoices = current_user.invoices
  end

  def new
    @client_list = current_user.clients.map { |c| [c.name, c.id] }
    @invoice = current_user.invoices.new(
      :invoice_number => current_user.next_invoice_number,
      :invoice_items  => [InvoiceItem.new])
  end

  def create
    @invoice = current_user.invoices.new(invoice_params)
    if @invoice.save
      current_user.increment!(:next_invoice_number)
      redirect_to @invoice
    else
      render 'new'
    end
  end

  def show
    @invoice = current_user.invoices.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "faktura_#{@invoice.invoice_number}",
               disposition: 'attachment',
               encoding: 'utf8'
      end
    end
  end

  def email_invoice
    @user = current_user
    @invoice = current_user.invoices.find(params[:id])
    @client = @invoice.client
    @type = @invoice.kreditnota ? 'kreditnota' : 'faktura'
  end

  def send_email_invoice
    @invoice = current_user.invoices.find(params[:id])
    message = params[:message]

    UserMailer.pdf_email(@invoice, message).deliver_now
    @invoice.update_attribute(:sends, @invoice.sends + 1)
    redirect_to invoices_path
    flash[:notice] = 'Faktura er sendt til kunde.'
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
    @invoice.assign_attributes(notes: "Kreditnota for faktura
      #{@invoice_to_credit.invoice_number}", kreditnota: true)

    @client_list = current_user.clients.map { |c| [c.name, c.id] }
    @products = current_user.products.all

    @invoice.invoice_number = current_user.next_invoice_number
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :notes, :client_id, :user_name, :user_org_number, :user_email,
      :user_phone, :user_bank_swift, :user_bank_iban, :user_bank_name,
      :user_bank_account, :user_address, :user_ref, :invoice_number,
      :kreditnota, :due_date, :order_date, :delivery_date, :total, :currency,
      :paid, :client_name, :client_email, :client_address, :delivery_address,
      :client_ref, :client_org_nr,
      invoice_items_attributes: [:id, :description, :quantity, :vat, :unit,
                                 :unit_price, :total, :user_id, :invoice_id,
                                 :_destroy])
  end
end
