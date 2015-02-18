class UserMailer < ActionMailer::Base
  # Needed for finn_grunnlag method used in pdf generation
  helper :invoices

  # Unless sender is defined in mailer
  default from: 'noreply@barefaktura.no'

  # Gets sent when a user signs up
  def welcome_email(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail to: email_with_name, subject: 'Velkommen til BareFaktura' do |format|
      format.html # renders welcome_email.html.erb for body of email
    end
  end

  # Sends an email with a summary of given invoice to invoice recipient
  # and attaches the invoice in pdf format
  def pdf_email(invoice, message)
    @invoice = invoice
    @message = message

    mail to: email_with_name(@invoice), from: sender_with_name(@invoice),
         bcc: @invoice.user.email, subject: email_subject(@invoice) do |format|
      format.html # renders pdf_email.html.erb for body of email
      format.pdf do
        attachments[email_subject(@invoice) + '.pdf'] = WickedPdf.new.pdf_from_string(
          render_to_string('invoices/show.pdf.erb'), encoding: 'utf8')
      end
    end
  end

  private

  # Returns sender name and email in the following format:
  # Firstname Lastname <name@email.com>
  def sender_with_name(invoice)
    %("#{invoice.user.name}" <#{invoice.user.email}>)
  end

  # Returns recipient name and email in the following format:
  # Firstname Lastname <name@email.com>
  def email_with_name(invoice)
    %("#{invoice.client.name}" <#{invoice.client.email}>)
  end

  # Returns a string in the following format:
  # Faktura/Kreditnota n, where n is invoice number
  def email_subject(invoice)
    "#{invoice.kreditnota ? 'kreditnota' : 'faktura'}
     #{invoice.invoice_number}"
  end
end
