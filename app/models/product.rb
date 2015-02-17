class Product < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates_presence_of :description, :unit, :price, :vat, :product_number
  validates_numericality_of :price, message: "må være et tall. Gyldige eksempler er \"100\", \"0,5\" eller \"0.50\""
  validates_format_of :price, with: /\A\d+(\.\d{1,2})?\z/, allow_blank: false, on: :create
  validates_numericality_of :vat, message: 'må være et heltall.'
  validates_format_of :vat, with: /\A\d{1,2}\z/, allow_blank: false, on: :create

  # Replaces comma with period and strips spaces
  def price=(price)
    price = price.to_s.gsub(',', '.') # comma to dot
    price = price.gsub(' ', '') # remove blanks
    self[:price] = price  # or perhaps price.to_f
  end

  # Returns product number and description as string
  def product_with_number
    "[#{product_number}] #{description}"
  end
end
