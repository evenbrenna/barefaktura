# Invoice model
class Invoice < ActiveRecord::Base
  # Default scopes
  default_scope { order('invoice_number DESC') }

  # Associations
  belongs_to :user
  belongs_to :client
  has_many :invoice_items, :inverse_of => :invoice, :dependent => :destroy
  accepts_nested_attributes_for :invoice_items, :allow_destroy => true,
                                                :reject_if     => :all_blank

  # Validations
  validates :user,             :presence => true
  validates :client,           :presence => true, :on => :save
  validates :invoice_items,    :presence => true
  validates :invoice_number,   :presence => true
  validates :currency,         :presence => true
  validates :delivery_date,    :presence => true
  validates :due_date,         :presence => true
  validates :client_name,      :presence => true
  validates :client_address,   :presence => true
  validates :delivery_address, :presence => true
  validates :total,            :presence => true, :on => :save

  # Callbacks
  before_save :store_user_data
  before_save :calculate_total
  before_save :save_client_if_new

  # Scopes
  scope :unpaid,       -> { where(:paid => false) }
  scope :overdue,      -> { unpaid.where('due_date < ?', Date.today) }

  def self.current_year
    dt = DateTime.new(2015)
    boy = dt.beginning_of_year
    eoy = dt.end_of_year
    where('created_at >= ? and created_at <= ?', boy, eoy)
  end

  # Duplicates the invoice and returns the copy. Needed
  # to make sure all items are duplicated for kreditnota.
  def replicate
    replica = dup
    invoice_items.each do |item|
      replica.invoice_items << item.dup
    end
    replica
  end

  def type
    kreditnota ? 'kreditnota' : 'faktura'
  end

  def to_s
    "#{type} #{invoice_number}"
  end

  private

  # Stores the needed user/sender information in the invoice object
  # rubocop:disable Metrics/AbcSize
  def store_user_data
    assign_attributes(:user_name         => user.name,
                      :user_org_number   => user.org_nr_with_registrations,
                      :user_email        => user.email,
                      :user_phone        => user.phone,
                      :user_bank_swift   => user.bank_swift,
                      :user_bank_iban    => user.bank_iban,
                      :user_bank_name    => user.bank_name,
                      :user_bank_account => user.bank_account,
                      :user_address      => user.address)
  end
  # rubocop:enable Metrics/AbcSize

  # Creates and assigns a new client if a client_id
  # is not specified for the invoice
  # rubocop:disable Metrics/AbcSize
  def save_client_if_new
    return unless client_id.blank?
    new_client = user.clients.new(:name             => client_name,
                                  :email            => client_email,
                                  :address          => client_address,
                                  :delivery_address => delivery_address,
                                  :ref              => client_ref,
                                  :org_nr           => client_org_nr)
    # rubocop:enable Metrics/AbcSize

    # saves the client and assigns its id to self
    return unless self.valid?
    new_client.save
    self[:client_id] = new_client.id
  end

  # Calculates and stores the invoice total
  def calculate_total
    total = 0.0
    invoice_items.each do |i|
      total += (i.quantity * i.unit_price * ((i.vat.to_f / 100) + 1))
    end
    self[:total] = total
  end
end
