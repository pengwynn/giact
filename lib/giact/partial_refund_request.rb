module Giact
  class PartialRefundRequest < RefundRequest
    include Validatable
    
    validates_each :partial_refund_amount, :logic => lambda { errors.add(:partial_refund_amount, "must be greater than zero") if self[:partial_refund_amount].to_f == 0.0 }
    
    def partial_refund_amount
     self[:partial_refund_amount].to_f
    end
    
    def test?
      self.test.to_s == "true"
    end
    
    def test
      self[:test] ||= Giact.test_mode?
    end
    
    def to_request
      self[:partial_refund_amount] = "%.2f" % self[:partial_refund_amount]
      {}.merge!(self).camelize_keys!
    end
    
  end
end