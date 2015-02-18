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

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :org_number, presence: true
  validates :bank_name, presence: true
  validates :bank_account, presence: true
  validates :next_invoice_number,
            presence: true,
            numericality: { message: 'må være et heltall.' },
            format: /\A\d+\z/, allow_blank: false, on: :create

  after_create :send_welcome_email

  private

  # Sends a welcome email to user.
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
    # Unused resque job (due to need for expensive dynos)
    # WelcomeEmailJob.new(self).enqueue(wait: 5.minutes)
  end
end
