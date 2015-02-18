class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice, inverse_of: :invoice_items

  validates :invoice,
            presence: true
  validates :description,
            presence: true
  validates :unit,
            presence: true
  validates :quantity,
            presence: true,
            numericality: { message: "må være et tall. Gyldige eksempler er \"99\", \"99,5\" eller \"99.50\"" },
            format: /\A\d+(\.\d{1,2})?\z/,
            allow_blank: false,
            on: :create
  validates :unit_price,
            presence: true
  validates :unit_price,
            numericality: { message: "må være et tall. Gyldige eksempler er \"99\", \"99,5\" eller \"99.50\"" },
            format: /\A\d+(\.\d{1,2})?\z/,
            allow_blank: false,
            on: :create
  validates :vat,
            presence: true,
            numericality: { message: 'må være et heltall.' },
            format: /\A\d{1,2}\z/,
            allow_blank: false,
            on: :create

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
