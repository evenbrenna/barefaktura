class UserMailer < ActionMailer::Base
  helper :application
  helper :invoices

  default from: 'noreply@barefaktura.no'

  def welcome_email(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail to: email_with_name, subject: 'Velkommen til BareFaktura' do |format|
      format.html # renders welcome_email.html.erb for body of email
    end
  end

  def pdf_email(invoice, message)
    @invoice = invoice
    @user = @invoice.user
    @client = @invoice.client
    @message = message
    @type = @invoice.kreditnota ? 'kreditnota' : 'faktura'
    @subject =  "#{@type} #{@invoice.invoice_number}"

    email_with_name = %("#{@client.name}" <#{@client.email}>)
    sender_with_name = %("#{@user.name}" <#{@user.email}>)

    mail to: email_with_name, bcc: @user.email, from: sender_with_name, subject: @subject do |format|
      format.html # renders pdf_email.html.erb for body of email
      format.pdf do
        attachments[@subject + '.pdf'] = WickedPdf.new.pdf_from_string(
          render_to_string('invoices/show.pdf.erb'), print_media_type: false, encoding: 'utf8')
      end
    end
  end
end
