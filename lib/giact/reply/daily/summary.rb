module Giact
  class DailySummaryReply
    attr_reader :transactions, :scrubs, :errors, :passcount, :passamount
    
    def initialize(response)
      @transactions, @scrubs, @errors, @passcount, @passamount = response.split("|")
    end
    
    def scrubs
      @scrubs.to_i
    end
    
    def errors
      @errors.to_i
    end
    
    def passcount
      @passcount.to_i
    end
    
    def passamount
      @passamount.to_f
    end
  end
end