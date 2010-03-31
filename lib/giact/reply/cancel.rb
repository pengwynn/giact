module Giact
  class CancelReply
    attr_accessor :cancelled, :details
    
    def initialize(row="")
      @cancelled, @details = row.split("|")
    end
    
    def cancelled?
      @cancelled.downcase == 'true'
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::CancelReply.new(line)}
    end
  end
end