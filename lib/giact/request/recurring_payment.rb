module Giact
  class RecurringPaymentRequest < PaymentRequest    

    validates_each :recurring_amount, :logic => lambda { errors.add(:recurring_amount, "must be greater than zero") if recurring_amount.to_f == 0.0 }
    validates_each :frequency_type, :logic => lambda { errors.add(:frequency_type, "is invalid") unless FREQUENCY_TYPES.include?(frequency_type)}
    
    FREQUENCY_TYPES = %w(Weekly Biweekly Semimonthly Monthly Quarterly Semiannually Annually)
    
    def recurring_amount
      "%.2f" % self[:recurring_amount].to_f
    end
  
    def frequency_type
      self[:frequency_type].to_s.gsub("_", "").capitalize
    end
  
    def recurring_start_date
      if self[:recurring_start_date].respond_to?(:year)
        self[:recurring_start_date].strftime("%m/%d/%Y")
      else
        self[:recurring_start_date]
      end
    end
    
  end
end