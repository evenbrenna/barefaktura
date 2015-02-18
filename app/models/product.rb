class Product < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :description, presence: true
  validates :unit, presence: true
  validates :price, presence: true
  validates :vat, presence: true
  validates :product_number, presence: true
  validates :price, numericality: true, message: "må være et tall. Gyldige eksempler er \"100\", \"0,5\" eller \"0.50\""
  validates :price, format: /\A\d+(\.\d{1,2})?\z/, allow_blank: false, on: :create
  validates :vat, numericality: true, message: 'må være et heltall.'
  validates :vat, format: /\A\d{1,2}\z/, allow_blank: false, on: :create

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
