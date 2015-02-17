class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice, inverse_of: :invoice_items

  validates_presence_of :invoice
  validates_presence_of :description, :quantity, :unit, :unit_price, :vat
  validates_numericality_of :quantity, message: "må være et tall. Gyldige eksempler er \"99\", \"99,5\" eller \"99.50\""
  validates_format_of :quantity, with: /\A\d+(\.\d{1,2})?\z/, allow_blank: false, on: :create
  validates_numericality_of :unit_price, message: "må være et tall. Gyldige eksempler er \"99\", \"99,5\" eller \"99.50\""
  validates_format_of :unit_price, with: /\A\d+(\.\d{1,2})?\z/, allow_blank: false, on: :create
  validates_numericality_of :vat, message: 'må være et heltall.'
  validates_format_of :vat, with: /\A\d{1,2}\z/, allow_blank: false, on: :create

  # Replaces comma with period and strips spaces
  def unit_price=(unit_price)
    unit_price = unit_price.to_s.gsub(',', '.')
    unit_price = unit_price.gsub(' ', '')
    self[:unit_price] = unit_price
  end

  # Replaces comma with period and strips spaces
  def quantity=(quantity)
    quantity = quantity.to_s.gsub(',', '.')
    quantity = quantity.gsub(' ', '')
    self[:quantity] = quantity
  end
end
