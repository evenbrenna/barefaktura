# Products is a representation of an item or service
# that can be transferred to an invoice item
class Product < ActiveRecord::Base
  # Sort by product number as default
  default_scope { order('product_number ASC') }

  # Associations
  belongs_to :user

  # Validations
  validates :user,           :presence     => true
  validates :description,    :presence     => true
  validates :unit,           :presence     => true
  validates :product_number, :presence     => true
  validates :price,          :presence     => true,
                             :numericality => { :message =>
                                                'må være et tall.' },
                             :format       => /\A\d+(\.\d{1,2})?\z/,
                             :allow_blank  => false,
                             :on           => :create
  validates :vat,            :presence     => true,
                             :numericality => { :message =>
                                                'må være heltall.' },
                             :format       => /\A\d{1,2}\z/,
                             :allow_blank  => false,
                             :on           => :create

  # Replaces comma with period and strips spaces
  def price=(price)
    price = price.to_s.gsub(',', '.')
    price = price.gsub(' ', '')
    self[:price] = price
  end

  # Returns product number and description as string
  def product_with_number
    "[#{product_number}] #{description}"
  end
end
