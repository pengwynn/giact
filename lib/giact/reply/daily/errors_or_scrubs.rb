module Giact
  class DailyErrorsOrScrubsReply
    attr_reader :transaction_id, :time_stamp, :error, :pass, :details, :customer_id, :order_id, 
                :name_oncheck, :address_line1, :address_line2, :address_line3, :name_ofbank, 
                :routing_number, :account_number, :check_number, :amount, :is_recurring, 
                :recurring_amount, :recurring_frequency, :recurring_startdate, :is_installments, 
                :installments_count, :installment_amount, :installments_startdate
    
    def initialize(response)
      @transaction_id, @time_stamp, @error, @pass, @details, @customer_id, @order_id, 
      @name_oncheck, @address_line1, @address_line2, @address_line3, @name_ofbank, 
      @routing_number, @account_number, @check_number, @amount, @is_recurring, 
      @recurring_amount, @recurring_frequency, @recurring_startdate, @is_installments, 
      @installments_count, @installment_amount, @installments_startdate = response.split("|")
    end
  end
end