# Mailers for emails to or invoked by users
class UserMailer < ActionMailer::Base
  # Needed for finn_grunnlag method used in pdf generation
  helper :invoices

  # Unless sender is defined in mailer
  default :from => 'Bare Faktura <post@barefaktura.no>'

  # Gets sent when a user signs up
  def welcome_email(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail :to      => email_with_name,
         :subject => 'Velkommen til BareFaktura' do |format|
      format.html # renders welcome_email.html.erb for body of email
    end
  end

  # Sends an email with a summary of given invoice to invoice recipient
  # and attaches the invoice in pdf format
  def pdf_email(invoice, message)
    @invoice, @message = invoice, message

    mail :to => email_with_name(@invoice), :from => sender_with_name(@invoice),
         :bcc => sender_with_name(@invoice),
         :subject => "#{@invoice.to_s.capitalize}" do |format|
      format.html # Render email html body
      format.pdf do # Render pdf attachment
        attachments[pdf_filename(@invoice)] = WickedPdf.new.pdf_from_string(
          render_to_string('invoices/show.pdf.erb'), :encoding => 'utf8')
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

  def pdf_filename(invoice)
    filename = invoice.to_s
    filename = filename.gsub!(' ', '_')
    "#{filename}.pdf"
  end
end
