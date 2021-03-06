# A Client is a recipient of one or more invoices.
# Created by a User or created automatically by Invoice controller.
class Client < ActiveRecord::Base
  # Sort by name as default
  default_scope { order('name ASC') }

  # Associations
  belongs_to :user
  has_many :invoices, :dependent => :restrict_with_exception

  # Validations
  validates :user,             :presence => true
  validates :name,             :presence => true
  validates :address,          :presence => true
  validates :delivery_address, :presence => true

  # Returns the sum of all invoices sent to the client as a float
  def total_invoiced
    total = 0.0
    invoices.each do |i|
      i.kreditnota ? total -= i.total : total += i.total
    end
    total
  end

  def self.select_map
    all.map { |c| [c.name, c.id] }
  end
end
