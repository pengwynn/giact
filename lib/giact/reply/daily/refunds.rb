module Giact
  class DailyRefundsReply
    attr_reader :transaction_id, :customer_id, :order_id, :payable_to, :address_line1, :address_line2, 
                :address_line3, :original_amount, :refund_amount, :check_number, :account_number
    
    def initialize(response)
      @transaction_id, @customer_id, @order_id, @payable_to, @address_line1, @address_line2, 
        @address_line3, @original_amount, @refund_amount, @check_number, @account_number = response.split("|")
    end
  end
end