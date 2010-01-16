module Giact
  class PaymentReply
    attr_reader :transaction_id, :error, :pass, :details, :code
    
    def initialize(response)
      @transaction_id, @error, @pass, @details, @code = response.split("|")
    end
    
    def transaction_id
      @transaction_id.to_i == 0 ? nil : @transaction_id.to_i
    end
    
    def error?
      @error.to_s == 'true'
    end
    
    def pass?
      @pass.to_s == 'true'
    end
    
  end
end