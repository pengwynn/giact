module Giact
  class Client < Giact::Request
    attr_reader :company_id
    
    # Return an authentication token 
    #
    # @return [String] authentication token
    def login
      response = self.class.post("Login", :companyID => @company_id, :un => @username, :pw => @password).perform
      if auth_token = parse(response)
        @token = auth_token
      else
        raise Giact::Unauthorized.new(response.body)
      end
    end
    
    # Returns current authentication token or calls login
    #
    # @return [String] authentication token
    def token
      @token ||= self.login
    end
    
    # Process a single payment
    #
    # @param [Giact::PaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def single_payment(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      raise Giact::InvalidRequest.new(payment_request.errors.full_messages) unless payment_request.valid?
      
      response = self.class.post("SinglePayment", payment_request.to_request_hash).perform
      if reply = parse(response)
        Giact::PaymentReply.new(reply)
      else
        raise response.body
      end
    end
    
    # Process recurring payments
    #
    # @param [Giact::RecurringPaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def recurring_payments(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      raise Giact::InvalidRequest.new(payment_request.errors.full_messages) if not payment_request.is_a?(Giact::RecurringPaymentRequest) or not payment_request.valid?
      
      response = self.class.post("RecurringPayments", payment_request.to_request_hash).perform
      if reply = parse(response)
        Giact::PaymentReply.new(reply)
      else
        
      end
    end
    
    # Process installment payments
    #
    # @param [Giact::InstallmentPaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def installments_payments(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      raise Giact::InvalidRequest.new(payment_request.errors.full_messages) if not payment_request.is_a?(Giact::InstallmentPaymentRequest) or not payment_request.valid?
      
      response = self.class.post("InstallmentsPayments", payment_request.to_request_hash).perform
      if reply = parse(response)
        Giact::PaymentReply.new(reply)
      else
        
      end
    end
    
    # @param [Hash] options method options
    # @option options [String] :transaction_id Transaction ID to list checks
    # @option options [String] :order_id Order ID to list checks
    def recurring_checks(options={})
      
      path = "RecurringChecksBy#{options.keys.first.to_s.camelize.gsub(/Id$/, "ID")}"
      options.merge!(:company_id => self.company_id, :token => self.token)
      options.camelize_keys!
      
      response = self.class.post(path, options).perform
      Giact::RecurringCheckList.from_response(parse(response))
    end
    
    # @param [Hash] options method options
    # @option options [String] :transaction_id Transaction ID for which to cancel checks
    # @option options [String] :order_id Order ID for which to cancel checks
    def cancel_recurring(options={})
      
      path = "CancelRecurringBy#{options.keys.first.to_s.camelize.gsub(/Id$/, "ID")}"
      options.merge!(:company_id => self.company_id, :token => self.token)
      options.camelize_keys!
      
      response = self.class.post(path, options).perform
      Giact::CancelRecurringCheckList.from_response(parse(response))
    end
    

    # @param [Hash] options method options
    # @option options [String] :name_on_check Name on check to search
    # @option options [String] :customer_id Customer ID to search
    # @option options [String] :order_id Order ID to search
    def search_transactions(options={})
      
      path = "TransactionsBy#{options.keys.first.to_s.camelize.gsub(/Id$/, "ID")}"
      options.merge!(:company_id => self.company_id, :token => self.token)
      options.camelize_keys!
      
      response = self.class.post(path, options).perform
      Giact::TransactionResult.from_response(parse(response))
    end  
  end
end