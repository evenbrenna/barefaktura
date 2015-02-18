class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  has_many :invoice_items, inverse_of: :invoice, dependent: :destroy
  accepts_nested_attributes_for :invoice_items,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :user, presence: true
  validates :client, presence: true, on: :save
  validates :invoice_items, presence: true
  validates_presence_of :invoice_number,
                        :currency,
                        :delivery_date,
                        :due_date,
                        :client_name,
                        :client_address,
                        :delivery_address

  before_save :store_user_data
  before_save :calculate_total
  before_save :save_new_client

  # Duplicates the invoice and returns the copy. Needed
  # to make sure all items are duplicated for kreditnota.
  def replicate
    replica = dup
    invoice_items.each do |item|
      replica.invoice_items << item.dup
    end
    replica
  end

  private

  # Stores the needed user/sender information
  # in the invoice object
  def store_user_data
    user = User.find(user_id)
    assign_attributes(
      user_name: user.name,
      user_org_number: ((user.foretaks_reg ? 'Foretaksregisteret ' : 'Org.nr: ') + (
                        user.org_number) + (user.mva_reg ? ' MVA' : '')),
      user_email: user.email,
      user_phone: user.phone,
      user_bank_swift: user.bank_swift,
      user_bank_iban: user.bank_iban,
      user_bank_name: user.bank_name,
      user_bank_account: user.bank_account,
      user_address: user.address)
  end

  # Creates and assigns a new client if
  # a client_id is not specified for the invoice
  def save_new_client
    if client_id.blank?
      user = User.find(user_id)
      new_client = user.clients.new(
        name: client_name,
        email: client_email,
        address: client_address,
        delivery_address: delivery_address,
        ref: client_ref,
        org_nr: client_org_nr)

      # saves the client and assigns its id to self
      if self.valid?
        new_client.save
        assign_attributes(client_id: new_client.id)
      end
    end
  end

  # Calculates and stores the invoice total
  def calculate_total
    total = 0.0
    invoice_items.each do |item|
      total += (item.quantity * item.unit_price * ((item.vat.to_f / 100) + 1))
    end
    self.total = total
  end
end
