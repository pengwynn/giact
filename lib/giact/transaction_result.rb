module Giact
  class TransactionResult   
    attr_reader :transaction_id
    attr_reader :timestamp
    attr_reader :error
    attr_reader :pass
    attr_reader :details
    attr_reader :customer_id
    attr_reader :order_id
    attr_reader :name_on_check
    attr_reader :address_line_1
    attr_reader :address_line_2
    attr_reader :address_line_3
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
    attr_reader :refund_transaction_id
    attr_reader :refund_customer_id
    attr_reader :refund_order_id
    attr_reader :payable_to
    attr_reader :refund_address_line_1
    attr_reader :refund_address_line_2
    attr_reader :refund_address_line_3
    attr_reader :original_amount
    attr_reader :refund_amount
    attr_reader :refund_check_number
    attr_reader :refund_account_number
    
    def initialize(row="")
      @transaction_id,  @timestamp,  @error,  @pass,  @details,  @customer_id,  @order_id,  @name_on_check,  @address_line_1,  @address_line_2,  @address_line_3,  @name_of_bank,  @routing_number,  @account_number,  @check_number,  @amount,  @is_recurring,  @recurring_amount,  @recurring_frequency,  @recurring_start_date,  @is_installments,  @installments_count,  @installment_amount,  @installments_start_date,  @returned,  @returned_date,  @returned_reason,  @returned_reason_code,  @refunded,  @refund_date,  @refund_transaction_id,  @refund_customer_id,  @refund_order_id,  @payable_to,  @refund_address_line_1,  @refund_address_line_2,  @refund_address_line_3,  @original_amount,  @refund_amount,  @refund_check_number,  @refund_account_number = row.split("|")
    end
    
    def transaction_id
      @transaction_id.blank? ? nil : @transaction_id.to_i
    end
    
    def timestamp
      Time.parse(@timestamp)
    end
    
    def amount
      @amount.to_f
    end
    
    def check_number
      @check_number.to_i
    end
    
    def routing_number
      @routing_number.to_i
    end
    
    def account_number
      @account_number.to_i
    end
    
    def refund_transaction_id
      @refund_transaction_id.blank? ? nil : @refund_transaction_id.to_i
    end
    
    def refund_check_number
      @refund_check_number.to_i
    end
    
    def refund_routing_number
      @refund_routing_number.to_i
    end
    
    def refund_account_number
      @refund_account_number.to_i
    end
    
    def refund_amount
      @refund_amount.to_f
    end
    
    def is_recurring?
      @is_recurring.to_s.downcase == "true"
    end
    
    def recurring_frequency
      @recurring_frequency.underscore
    end
    
    def error?
      @error.to_s.downcase == "true"
    end
    
    def pass?
      @pass.to_s.downcase == "true"
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::TransactionResult.new(line)}
    end
  end
end