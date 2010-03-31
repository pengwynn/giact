module Giact
  class DailyReturnsReply
    attr_reader :transaction_id, :customer_id, :order_id, :reason_code, :reason, :returned_date
    
    def initialize(response)
      @transaction_id, @customer_id, @order_id, @reason_code, @reason, @returned_date = response.split("|")
    end
  end
end