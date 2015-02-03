class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  def role?(r)
    role.include? r.to_s
  end

  has_many :clients, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates_presence_of :name, :email, :address, :org_number, :bank_name, :bank_account, :next_invoice_number
  validates_numericality_of :next_invoice_number, message: "må være et heltall."
  validates_format_of :next_invoice_number, with: /\A\d+\z/, allow_blank: false, on: :create

  after_create :send_welcome_email

  private
    def send_welcome_email
      UserMailer.welcome_email(self).deliver_now
      # Ubrukt resque job
      # WelcomeEmailJob.new(self).enqueue(wait: 5.minutes)
    end
end
