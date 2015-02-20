class User < ActiveRecord::Base
  # Associations
  has_many :clients, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :invoices, dependent: :destroy

  # Validations
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

  # Callbacks
  after_create :send_welcome_email

  # Devise modules.
  # Others available are: :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  # Returns true if argument matches user role
  def role?(r)
    role.include? r.to_s
  end

  # Returns org.nr with registrations as a string
  def org_nr_with_registrations
    (foretaks_reg ? 'Foretaksregisteret ' : 'Org.nr: ') +
      org_number + (mva_reg ? ' MVA' : '')
  end

  private

  # Sends a welcome email to user.
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
    # Unused resque job (due to need for expensive dynos)
    # WelcomeEmailJob.new(self).enqueue(wait: 5.minutes)
  end
end
