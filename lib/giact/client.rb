module Giact
  class Client
    include HTTParty
    format :xml
    
    attr_reader :company_id
        
    # @param [Hash] options method options
    # @option options [Integer] :gateway Number (1-3) of gateway server to use
    # @option options [String] :company_id Your Giact company ID
    # @option options [String] :username Your Giact API username
    # @option options [String] :password Your Giact API password
    def initialize(options={})
      options[:gateway] ||= 1
      self.class.base_uri("https://gatewaydtx#{options[:gateway]}.giact.com/RealTime/POST/RealTimeChecks.asmx")
      
      @company_id ||= Giact.company_id ||= options[:company_id]
      @username ||= Giact.username ||= options[:username]
      @password ||= Giact.password ||= options[:password]
    end
    
    
    # Return an authentication token 
    #
    # @return [String] authentication token
    def login
      response = self.class.post("/Login", :body => {:companyID => @company_id, :un => @username, :pw => @password})
      if auth_token = response['string']
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
      
      response = self.class.post("/SinglePayment", :body => payment_request.to_request_hash)
      if reply = response['string']
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
      
      response = self.class.post("/RecurringPayments", :body => payment_request.to_request_hash)
      if reply = response['string']
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
      
      response = self.class.post("/InstallmentsPayments", :body => payment_request.to_request_hash)
      if reply = response['string']
        Giact::PaymentReply.new(reply)
      else
        
      end
    end
    


    def search_transactions(options={})
      path = case options.keys.first
      when :order_id
        "TransactionsByOrderID"
      when :customer_id
        "TransactionsByCustomerID"
      when :name_on_check
        "TransactionsByNameOnCheck"
      end
      
      options.merge!(:company_id => self.company_id, :token => self.token)
      options.keys.each {|key| options[key.camelize] = options.delete(key) }
      
      response = self.class.get(path, :body => options)['string']
      Giact::TransactionResult.from_response(response)
    end
    
    

  
  end
end