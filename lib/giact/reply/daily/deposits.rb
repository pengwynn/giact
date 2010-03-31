module Giact
  class DailyDepositsReply
    attr_reader :batch_id, :count, :amount
    
    def initialize(response)
      @batch_id, @count, @amount = response.split("|")
    end
    
    def count
      @count.to_i
    end
    
    def amount
      @amount.to_f
    end
  end
end