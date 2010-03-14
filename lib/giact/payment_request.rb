module Giact
  class PaymentRequest < Hashie::Mash
    include Validatable    
    
    validates_presence_of :company_id
    validates_presence_of :token
    validates_presence_of :customer_id
    validates_presence_of :order_id
    validates_presence_of :name_on_check
    validates_presence_of :address_line_1
    validates_presence_of :address_line_2
    validates_presence_of :address_line_3
    validates_presence_of :name_of_bank
    validates_presence_of :routing_number
    validates_presence_of :account_number
    validates_presence_of :check_number
    validates_each :amount, :logic => lambda { errors.add(:amount, "must be greater than zero") if self[:amount].to_f == 0.0 }
    
    
    def amount
     self[:amount].to_f
    end
    
    def test?
      self.test.to_s == "true"
    end
    
    def test
      self[:test] ||= Giact.test_mode?
    end
    
    def to_request_hash
      h = {}
      self[:test] = Giact.test_mode?
      self[:amount] = "%.2f" % self[:amount]
      self.each do |key, value|
        h[key.to_s.camelize.gsub(/Id$/, "ID")] = value
      end
      h
    end
    
  end
  
end