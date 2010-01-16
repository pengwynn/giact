module Giact
  class TransactionResult   
    attr_reader :transaction_id
    attr_reader :time_stamp
    attr_reader :error
    attr_reader :pass
    attr_reader :details
    attr_reader :customer_id
    attr_reader :order_id
    attr_reader :name_on_check
    attr_reader :address_line1
    attr_reader :address_line2
    attr_reader :address_line3
    attr_reader :name_of_bank
    attr_reader :routing_number
    attr_reader :account_number
    attr_reader :check_number
    attr_reader :amount
    attr_reader :is_recurring
    attr_reader :recurring_amount
    attr_reader :recurring_frequency
    attr_reader :recurring_start_date
    attr_reader :is_installments
    attr_reader :installments_count
    attr_reader :installment_amount
    attr_reader :installments_start_date
    attr_reader :returned
    attr_reader :returned_date
    attr_reader :returned_reason
    attr_reader :returned_reason_code
    attr_reader :refunded
    attr_reader :refund_date
    attr_reader :transaction_id
    attr_reader :customer_id
    attr_reader :order_id
    attr_reader :payable_to
    attr_reader :address_line1
    attr_reader :address_line2
    attr_reader :address_line3
    attr_reader :original_amount
    attr_reader :refund_amount
    attr_reader :check_number
    attr_reader :account_number
    
    def initialize(row="")
      @transaction_id,  @time_stamp,  @error,  @pass,  @details,  @customer_id,  @order_id,  @name_on_check,  @address_line1,  @address_line2,  @address_line3,  @name_of_bank,  @routing_number,  @account_number,  @check_number,  @amount,  @is_recurring,  @recurring_amount,  @recurring_frequency,  @recurring_start_date,  @is_installments,  @installments_count,  @installment_amount,  @installments_start_date,  @returned,  @returned_date,  @returned_reason,  @returned_reason_code,  @refunded,  @refund_date,  @transaction_id,  @customer_id,  @order_id,  @payable_to,  @address_line1,  @address_line2,  @address_line3,  @original_amount,  @refund_amount,  @check_number,  @account_number = row.split("|")
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::TransactionResult.new(line)}
    end
  end
end