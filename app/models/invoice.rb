class Invoice < ActiveRecord::Base

    belongs_to :user
    belongs_to :client
    has_many :invoice_items, inverse_of: :invoice, dependent: :destroy

    validates :user, :presence => true
    validates :client, :presence => true, :on => :save
    validates :invoice_items, :presence => true

    accepts_nested_attributes_for :invoice_items,
        :allow_destroy => true,
        :reject_if     => :all_blank

    validates_presence_of :invoice_number,
                        :currency,
                        :delivery_date,
                        :due_date,
                        :client_name,
                        :client_address,
                        :delivery_address,
                        :user_name,
                        :user_org_number,
                        :user_email,
                        :user_bank_name,
                        :user_bank_account,
                        :user_address


    before_save :calculate_total

    def replicate
        replica = dup
        invoice_items.each do |item|
            replica.invoice_items << item.dup
        end
        replica
    end

    private

    def calculate_total
        total = 0.0
        self.invoice_items.each do |item|
            total += (item.quantity * item.unit_price * ((item.vat.to_f / 100) + 1))
        end
        self.total = total
    end

end

