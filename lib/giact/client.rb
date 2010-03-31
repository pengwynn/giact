module Giact
  class Client < Giact::Request
    attr_reader :company_id
    attr_accessor :authorized
    
    def authorized
      @authorized ||= false
    end
    
    def authorized?
      @authorized
    end
    
    # Return an authentication token 
    #
    # @return [String] authentication token
    def login
      unless authorized?
        response = post("Login", :companyID => @company_id, :un => @username, :pw => @password).perform
        if auth_token = parse(response)
          @authorized = true
          @token = auth_token
        else
          raise Giact::Unauthorized.new(response.body)
        end
      end
    end
    
    # Destroy the current session
    def logout
      if authorized?
        response = post("Logout", :companyID => @company_id, :token => @token).perform
        if parse(response)
          @authorized = false
        end
      end
    end
    
    # Returns current authentication token or calls login
    #
    # @return [String] authentication token
    def token
      @token ||= self.login
    end
    
    # Cancel By
    def cancel_method_by(method, type, id)
      request = {:company_id => self.company_id, :token => self.token, "#{type}_id".to_sym => id}.camelize_keys!
      
      response = post("Cancel#{method.capitalize!}By#{type.capitalize!}ID", request).perform
      Giact::CancelReply.from_response(parse(response))
    end
    
    
    # Process a single payment
    #
    # @param [Giact::PaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def single_payment(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      raise Giact::InvalidRequest.new(payment_request.errors.full_messages) unless payment_request.valid?
      
      response = post("SinglePayment", payment_request.to_request).perform
      Giact::PaymentReply.new(parse(response))
    end
    
    # Process recurring payments
    #
    # @param [Giact::RecurringPaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def recurring_payment(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      
      unless payment_request.is_a?(Giact::RecurringPaymentRequest) || payment_request.valid?
        raise Giact::InvalidRequest.new(payment_request.errors.full_messages)
      end 
      
      response = post("RecurringPayments", payment_request.to_request).perform
      Giact::PaymentReply.new(parse(response))
    end
    
    def list_recurring_by(type, id)
      request = {:company_id => self.company_id, :token => self.token, "#{type}_id".to_sym => id}.camelize_keys!
      
      response = post("RecurringChecksBy#{type.to_s.capitalize!}ID", request).perform
      Giact::RecurringCheckList.from_response(parse(response))
    end
    
    def list_recurring_by_order(id)
      list_recurring_by("order", id)
    end
    
    def list_recurring_by_transaction(id)
      list_recurring_by("transaction", id)
    end
    
    def cancel_recurring_by_order(id)
      cancel_method_by("recurring", "order", id)
    end
    
    def cancel_recurring_by_transaction(id)
      cancel_method_by("recurring", "transaction", id)
    end
    
    
    
    # Process installment payments
    #
    # @param [Giact::InstallmentPaymentRequest] payment_request Customer and payment info to be processed
    # @return [Giact::PaymentReply] Transaction information
    def installment_payment(payment_request)
      payment_request.merge!(:company_id => self.company_id, :token => self.token)
      
      if not payment_request.is_a?(Giact::InstallmentPaymentRequest) or not payment_request.valid?
        raise Giact::InvalidRequest.new(payment_request.errors.full_messages) 
      end
      
      response = post("InstallmentsPayments", payment_request.to_request).perform
      Giact::PaymentReply.new(parse(response))
    end
    
    
    def list_installments_by(type, id)
      request = {:company_id => self.company_id, :token => self.token, "#{type}_id".to_sym => id}.camelize_keys!
      
      response = post("InstallmentChecksBy#{type.to_s.capitalize!}ID", request).perform
      Giact::InstallmentsList.from_response(parse(response))
    end
    
    def list_installments_by_order(id)
      list_installments_by("order", id)
    end
    
    def list_installments_by_transaction(id)
      list_installments_by("transaction", id)
    end
    
    def cancel_installments_by_order(id)
      cancel_method_by("installments", "order", id)
    end
    
    def cancel_installments_by_transaction(id)
      cancel_method_by("installments", "transaction", id)
    end
    
    
    def cancel_transaction_by_order(id)
      cancel_method_by("transaction", "order", id)
    end
    
    def cancel_transaction_by_transaction(id)
      cancel_method_by("transaction", "transaction", id)
    end
    
    
    def refund_by(type, request)
      request.merge!(:company_id => self.company_id, :token => self.token)
      
      if not request.is_a?(Giact::RefundRequest) or not request.valid?
        raise Giact::InvalidRequest.new(request.errors.full_messages) 
      end
      
      response = post("RequestRefundBy#{type.capitalize!}ID", request.to_request).perform
      Giact::RefundReply.new(parse(response))
    end
    
    def refund_by_order(request)
      refund_by("order", request)
    end
    
    def refund_by_transaction(request)
      refund_by("transaction", request)
    end
    
    def partial_refund_by(type, request)
      request.merge!(:company_id => self.company_id, :token => self.token)
      
      if not request.is_a?(Giact::PartialRefundRequest) or not request.valid?
        raise Giact::InvalidRequest.new(request.errors.full_messages) 
      end
      
      response = post("RequestPartialRefundBy#{type.capitalize!}ID", request.to_request).perform
      Giact::RefundReply.new(parse(response))
    end
    
    def partial_refund_by_order(request)
      partial_refund_by("order", request)
    end
    
    def partial_refund_by_transaction(request)
      partial_refund_by("transaction", request)
    end
    
    
    def daily_summary(date)
      
    end
    
    def daily_deposits(date)
      
    end
    
    def daily_returns(date)
      
    end
    
    def daily_refunds(date)
      
    end
    
    def daily_scrubs(date)
      
    end
    
    
    def range_returns(start, finish)
      
    end
    
    def range_refunds(start, finish)
      
    end
    
    
    # @param [Hash] options method options
    # @option options [String] :name_on_check Name on check to search
    # @option options [String] :customer_id Customer ID to search
    # @option options [String] :order_id Order ID to search
    def search_transactions(options={})
      
      path = "TransactionsBy#{options.keys.first.to_s.camelize.gsub(/Id$/, "ID")}"
      options.merge!(:company_id => self.company_id, :token => self.token)
      options.camelize_keys!
      
      response = post(path, options).perform
      Giact::TransactionResult.from_response(parse(response))
    end  
  end
end