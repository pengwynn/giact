module Giact
  class RefundReply
    attr_reader :refunded, :details
    
    def initialize(response)
      @refunded, @details = response.split("|")
    end
    
    def refunded?
      @refunded.to_s == 'true'
    end
  end
end