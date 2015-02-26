# Actions related to invoices
class InvoicesController < ApplicationController
  # Authenticate with Devise, Authorize with CanCanCan
  before_action :authenticate_user!
  load_and_authorize_resource

  # rubocop:disable Metrics/AbcSize
  def index
    @invoices = current_user.invoices
    if params[:filter] == 'all'
      @invoice_list = current_user.invoices
    elsif params[:filter] == 'overdue'
      @invoice_list = current_user.invoices.overdue
    else
      @invoice_list = current_user.invoices.unpaid
    end
  end
  # rubocop:enable Metrics/AbcSize

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

    # Render html for online view or pdf for download
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf         => "faktura_#{@invoice.invoice_number}",
               :disposition => 'attachment',
               :encoding    => 'utf8'
      end
    end
  end

  # Renders _email_invoice.html.erb via email_invoice.js.erb
  def email_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  # Gets called by _email_invoice.html.erb submit button
  def send_email_invoice
    @invoice = current_user.invoices.find(params[:id])
    UserMailer.pdf_email(@invoice, params[:message]).deliver_now
    @invoice.increment!(:sends)
    flash[:notice] = 'Faktura er sendt til kunde.'
    redirect_to invoices_path
  end

  # Javascript reloads needed parts of view
  def set_paid
    @invoice = Invoice.find(params[:id])
    @invoice.toggle!(:paid)
    redirect_to :back
  end

  def kreditnota
    @to_credit = current_user.invoices.find(params[:id])
    @invoice = @to_credit.replicate
    @invoice.assign_attributes(
      :notes          => "Kreditnota for faktura #{@to_credit.invoice_number}",
      :kreditnota     => true,
      :invoice_number => current_user.next_invoice_number)
  end

  private

  # Helper method to increase invoice sends on send_email_invoice
  def increment_sends(invoice)
    invoice.update_attribute(:sends, invoice.sends + 1)
  end

  # Strong parameters
  def invoice_params
    params.require(:invoice).permit(
      :notes, :client_id, :user_name, :user_org_number, :user_email,
      :user_phone, :user_bank_swift, :user_bank_iban, :user_bank_name,
      :user_bank_account, :user_address, :user_ref, :invoice_number,
      :kreditnota, :due_date, :order_date, :delivery_date, :total, :currency,
      :paid, :client_name, :client_email, :client_address, :delivery_address,
      :client_ref, :client_org_nr,
      :invoice_items_attributes => [:id, :description, :quantity, :vat, :unit,
                                    :unit_price, :total, :user_id, :invoice_id,
                                    :_destroy])
  end
end
