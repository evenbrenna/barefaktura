class Client < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :invoices, dependent: :restrict_with_exception

  # Validations
  validates :user, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :delivery_address, presence: true

  # Returns total invoiced for client
  def total_invoiced
    total = 0.0
    invoices.each do |i|
      if i.kreditnota
        total -= i.total
      else
        total += i.total
      end
    end
    total
  end
end
