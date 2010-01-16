module Giact
  class InstallmentPaymentRequest < PaymentRequest
        
    validates_each :installment_amount, :logic => lambda { errors.add(:installment_amount, "must be greater than zero") if installment_amount.to_f == 0.0 }
    
    
    def installment_count
      self[:installment_amount].to_i
    end
    
    def installments_start_date
      if self[:installments_start_date].respond_to?(:year)
        self[:installments_start_date].strftime("%m/%d/%Y")
      else
        self[:installments_start_date]
      end
    end
    
  end
end