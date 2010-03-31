module Giact
  class RangeReportRequest < Hashie::Mash
    include Validatable    
    
    validates_presence_of :company_id
    validates_presence_of :token
    validates_presence_of :start_date
    validates_presence_of :end_date
    
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