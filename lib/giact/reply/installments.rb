module Giact
  class InstallmentsReply
    attr_accessor :check_id, :check_date, :installment_number, :returned, :refunded
    
    def initialize(row="")
      @check_id, @check_date, @installment_number, @returned, @refunded = row.split("|")
    end
    
    def check_id
      @check_id.to_i
    end
    
    def check_date
      Time.parse(@check_date)
    end
    
    def installment_number
      @installment_number.to_i
    end
    
    def returned?
      @returned.downcase == 'true'
    end
    
    def refunded?
      @refunded.downcase == 'true'
    end
    
    def self.from_response(response)
      response.split(/\n/).map{|line| Giact::InstallmentsReply.new(line)}
    end
  end
end