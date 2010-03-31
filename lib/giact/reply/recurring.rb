module Giact
  class RecurringReply
    attr_accessor :check_id, :check_date, :returned, :refunded
    
    def initialize(row="")
      @check_id, @check_date, @returned, @refunded = row.split("|")
    end
    
    def check_id
      @check_id.to_i
    end
    
    def check_date
      Time.parse(@check_date)
    end
    
    def returned?
      @returned.downcase == 'true'
    end
    
    def refunded?
      @refunded.downcase == 'true'
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::RecurringReply.new(line)}
    end
  end
end