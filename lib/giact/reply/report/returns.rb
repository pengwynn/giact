module Giact
  class RangeReturnsReply
    attr_reader :transaction_id, :customer_id, :order_id, :reason_code, :reason, :returned_date
    
    def initialize(response)
      @transaction_id, @customer_id, @order_id, @reason_code, @reason, @returned_date = response.split("|")
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::RangeReturnsReply.new(line)}
    end
  end
end