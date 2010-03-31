module Giact
  class RefundRequest < Hashie::Mash
    include Validatable
    
    validates_presence_of :company_id
    validates_presence_of :token
    validates_presence_of :payable_to
    validates_presence_of :address_line_1
    validates_presence_of :address_line_2
    validates_presence_of :city
    validates_presence_of :state
    validates_presence_of :zip
    
    
    def test?
      self.test.to_s == "true"
    end
    
    def test
      self[:test] ||= Giact.test_mode?
    end
    
    def to_request
      {}.merge!(self).camelize_keys!
    end
    
  end
end