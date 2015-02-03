class Client < ActiveRecord::Base

    belongs_to :user
    has_many :invoices, :dependent => :restrict_with_exception # raises ActiveRecord::DeleteRestrictionError

    validates :user, :presence => true
    validates_presence_of :name, :address, :delivery_address

    # calculates total invoiced for client
    def total_invoiced
        total = 0.0
        self.invoices.each do |i|
            if i.kreditnota
                total -= i.total
            else
                total += i.total
            end
        end
        total
    end
end
