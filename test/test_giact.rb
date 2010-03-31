require 'helper'

class TestGiact < Test::Unit::TestCase
  context "when using the Giact API" do
    setup do
      @client = Giact::Client.new(:company_id => 1976, :username => 'pengwynn', :password => 'OU812')
      stub_post("/Login", "login.xml")
    end

    should "be able to log in" do
      token = @client.login
      token.should == 'f7edf569-e946-45d0-82b0-5ee44e3c027d'
      @client.authorized.should == true
    end
    
    should "be able to log out" do
      @client.logout
      @client.authorized.should == false
    end
    
    should "retreive an auth token implicitly" do
      token = @client.token
      token.should == 'f7edf569-e946-45d0-82b0-5ee44e3c027d'
    end
    
    should "raise an error when failing to authenticate" do
      stub_post("/Login", "login_failed.txt")
      assert_raise Giact::Unauthorized do
        @client.authorized.should == false
        @client.token
      end
    end
    
    context "when processing single payments" do
      setup do
        @request = Giact::PaymentRequest.new({
          :customer_id => 'C1234',
          :order_id => 'O1234',
          :name_on_check => 'John Doe',
          :address_line_1 => '1313 Mockingbird Lane',
          :address_line_2 => 'Monroe, LA 71203',
          :address_line_3 => 'ph. (318) 867-5309',
          :name_of_bank => 'Ouachita National Bank',
          :routing_number => '123456789',
          :account_number => '990009773',
          :check_number => 4003,
          :amount => 75.00
        })
        
        stub_post("/Login", "login.xml")
      end
      
      should "raise an error if request is invalid" do
        assert_raise Giact::InvalidRequest do
          @request.check_number = nil
          result = @client.single_payment(@request)
        end
      end
  
      should "process single payments" do
        stub_post("/SinglePayment", "payment_pass.xml")
        result = @client.single_payment(@request)
        
        result.transaction_id.should == 1889756
        result.error?.should == false
        result.pass?.should == true
        result.details.should == 'Pass AV'
        result.code.should == '1111'
      end
    end
    
    context "when processing recurring payments" do
      setup do
        @request = Giact::RecurringPaymentRequest.new({
          :customer_id => 'C1234',
          :order_id => 'O1234',
          :name_on_check => 'John Doe',
          :address_line_1 => '1313 Mockingbird Lane',
          :address_line_2 => 'Monroe, LA 71203',
          :address_line_3 => 'ph. (318) 867-5309',
          :name_of_bank => 'Ouachita National Bank',
          :routing_number => '123456789',
          :account_number => '990009773',
          :check_number => 4003,
          :amount => 75.00,
          :recurring_amount => 24.95,
          :frequency_type => :monthly,
          :recurring_start_date => Time.now
        })
        
        stub_post("/Login", "login.xml")
      end
      
      should "raise an error if request is invalid" do
        assert_raise Giact::InvalidRequest do
          @request.recurring_amount = nil
          result = @client.single_payment(@request)
        end
      end
      
      should "raise an error if frequency type is not supported" do
        assert_raise Giact::InvalidRequest do
          @request.frequency_type = :fortnightly
          result = @client.single_payment(@request)
        end
      end
      
      should "process recurring payments" do
        stub_post("/RecurringPayments", "payment_pass.xml")
        result = @client.recurring_payment(@request)
        
        result.transaction_id.should == 1889756
        result.error?.should == false
        result.pass?.should == true
        result.details.should == 'Pass AV'
        result.code.should == '1111'
      end
    end
    
    context "when processing installment payments" do
      setup do
        @request = Giact::InstallmentPaymentRequest.new({
          :customer_id => 'C1234',
          :order_id => 'O1234',
          :name_on_check => 'John Doe',
          :address_line_1 => '1313 Mockingbird Lane',
          :address_line_2 => 'Monroe, LA 71203',
          :address_line_3 => 'ph. (318) 867-5309',
          :name_of_bank => 'Ouachita National Bank',
          :routing_number => '123456789',
          :account_number => '990009773',
          :check_number => 4003,
          :amount => 75.00,
          :installment_amount => 24.95,
          :installment_count => 4,
          :installments_start_date => 3.months.from_now
        })
        
        stub_post("/Login", "login.xml")
      end
      
      should "raise an error if request is invalid" do
        assert_raise Giact::InvalidRequest do
          @request.installment_amount = nil
          result = @client.installment_payment(@request)
        end
      end
      
      should "process installments payments" do
        stub_post("/InstallmentsPayments", "payment_pass.xml")
        result = @client.installment_payment(@request)
        
        result.transaction_id.should == 1889756
        result.error?.should == false
        result.pass?.should == true
        result.details.should == 'Pass AV'
        result.code.should == '1111'
      end
      
    end
 
    context "when in test mode" do
      setup do
        Giact.test_mode = true
      end
    
      should "persist test flag" do
        Giact.test_mode?.should == true
      end
      
      should "pass test flag to payment methods" do
        payment_request = Giact::PaymentRequest.new
        payment_request.test?.should == true
      end
    end
    
    should "list recurring checks for an order ID" do
      stub_post("/RecurringChecksByOrderID", "recurring_check_list.xml")
      results = @client.list_recurring_by_order("1234")
      results.size.should == 2
      results.first.check_id.should == 1001
      results.first.check_date.year.should == 2010
      results.last.returned?.should == true
    end
  
    should "list recurring checks for a transaction ID" do
      stub_post("/RecurringChecksByTransactionID", "recurring_check_list.xml")
      results = @client.list_recurring_by_transaction("1234")
      results.size.should == 2
      results.first.check_id.should == 1001
      results.first.check_date.year.should == 2010
      results.last.returned?.should == true
    end
  
    should "cancel future recurring checks by order ID" do
      stub_post("/CancelRecurringByOrderID", "cancel_recurring_check_list.xml")
      results = @client.cancel_recurring_by_order("1234")
      results.first.cancelled?.should == true
      results.last.cancelled?.should == false
      results.last.details.should == "No transactions were found for OrderID"
    end
  
    should "cancel future recurring checks by transaction ID" do
      stub_post("/CancelRecurringByTransactionID", "cancel_recurring_check_list.xml")
      results = @client.cancel_recurring_by_transaction("1234")
      results.first.cancelled?.should == true
      results.last.cancelled?.should == false
    end
    
    
    # should_eventually "list installment checks by order ID" do
    #   stub_post("/InstallmentChecksByOrderID", "installment_list.xml")
    #   #results = @client.list_installments_by_order("1234")
    # end
    # 
    # should_eventually "list installment checks by transaction ID" do
    #   stub_post("/InstallmentChecksByTransactionID", "installment_list.xml")
    #   #results = @client.list_installments_by_transaction("1234")
    # end
  # 
  #   should_eventually "cancel future installment checks by order ID" do
  # 
  #   end
  # 
  #   should_eventually "cancel future installment checks by transaction ID" do
  # 
  #   end
  # 
  #   should_eventually "cancel a transaction by order ID that has not been batched" do
  # 
  #   end
  # 
  #   should_eventually "cancel a transaction by transaction ID that has not been batched" do
  # 
  #   end
  # 
  #   should_eventually "request a refund by order ID" do
  # 
  #   end
  # 
  #   should_eventually "request a refund by transaction ID" do
  # 
  #   end
  # 
  #   should_eventually "request a partial refund by order ID" do
  # 
  #   end
  # 
  #   should_eventually "request a partial refund by transaction ID" do
  # 
  #   end
  # 
  #   should_eventually "return a daily summary" do
  # 
  #   end
  # 
  #   should_eventually "list daily deposits for a given date" do
  # 
  #   end
  # 
  #   should_eventually "list checks returned for a given date" do
  # 
  #   end
  # 
  #   should_eventually "list checks refunded for a given date" do
  # 
  #   end
  # 
  #   should_eventually "list transactions scrubbed for a given date" do
  # 
  #   end
  # 
  #   should_eventually "list errored transactions for a given date" do
  # 
  #   end
  # 
  #   should_eventually "list checks returned for a given date range" do
  # 
  #   end
  # 
  #   should_eventually "list checks refunded for a given date range" do
  # 
  #   end
  # 
    should "search transactions by order ID" do
      stub_post("/TransactionsByOrderID", "transaction_search.xml")
      results = @client.search_transactions(:order_id => "1234")
      results.first.transaction_id.should == 1889756
      results.first.address_line_1.should == '1313 MOCKINGBIRD LANE'

      results.last.transaction_id.should == 1890090
      results.last.is_recurring?.should == true
      results.last.recurring_frequency.should == 'monthly'
    end

    should "search transactions by customer ID" do
      stub_post("/TransactionsByCustomerID", "transaction_search.xml")
      results = @client.search_transactions(:customer_id => "1234")
      results.first.transaction_id.should == 1889756
      results.first.address_line_1.should == '1313 MOCKINGBIRD LANE'

      results.last.transaction_id.should == 1890090
      results.last.is_recurring?.should == true
      results.last.recurring_frequency.should == 'monthly'
    end

    should "search transactions by name on check" do
      stub_post("/TransactionsByNameOnCheck", "transaction_search.xml")
      results = @client.search_transactions(:name_on_check => "Willy Wonka")
      results.first.transaction_id.should == 1889756
      results.first.error?.should == false
      results.first.pass?.should == true
      results.first.address_line_1.should == '1313 MOCKINGBIRD LANE'

      results.last.transaction_id.should == 1890090
      results.last.is_recurring?.should == true
      results.last.recurring_frequency.should == 'monthly'
    end
  end
  
  context "when creating a payment request" do
    setup do
      @payment_request = Giact::PaymentRequest.new
    end

    should "require a company ID" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:company_id).should == "can't be empty"
    end
  
    should "require a token" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:token).should == "can't be empty"
    end
  
    should "require a customer ID" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:customer_id).should == "can't be empty"
    end
  
    should "require a order ID" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:order_id).should == "can't be empty"
    end
  
    should "require a name on check" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:name_on_check).should == "can't be empty"
    end
  
    should "require address info" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:address_line_1).should == "can't be empty"
      @payment_request.errors.on(:address_line_2).should == "can't be empty"
      @payment_request.errors.on(:address_line_3).should == "can't be empty"
    end
  
    should "require a name of bank" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:name_of_bank).should == "can't be empty"
    end
  
    should "require a routing number" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:routing_number).should == "can't be empty"
    end
  
    should "require an account number" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:account_number).should == "can't be empty"
    end
  
    should "require an amount" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:amount).should == "must be greater than zero"
    end
  
    should "support amount as float" do
      @payment_request.amount = 30.4
      @payment_request.to_request['Amount'].should == "30.40"
    end
  end
  
  context "when creating a recurring payment request" do
    setup do
      @payment_request = Giact::RecurringPaymentRequest.new
    end

    should "require a company ID" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:company_id).should == "can't be empty"
    end
  
    should "require a token" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:token).should == "can't be empty"
    end
  
    should "require an amount" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:amount).should == "must be greater than zero"
    end
  
    should "support amount as float" do
      @payment_request.amount = 30.4
      @payment_request.to_request['Amount'].should == "30.40"
    end
  
    should "require a recurring amount" do
      @payment_request.valid?.should == false
      @payment_request.errors.on(:amount).should == "must be greater than zero"
    end
  
    should "support recurring amount as float" do
      @payment_request.recurring_amount = 69.95
      @payment_request.recurring_amount.should == "69.95"
    end
  end

  context "when parsing transaction search results" do
    should "parse a single row" do
      row = "1890090|2010-01-15 14:49:41Z|False|True|Pass AV|C1234|O1235|Wonkawerks|1313 MOCKINGBIRD LANE|DALLAS, TX  76227|PH. 214-295-7561|Bank of America|320113000|006888995646|2350|5.00|True|5.00|Monthly|2010-02-15 00:00:00Z|False||||False||||False||||||||||||"
      result = Giact::TransactionResult.new(row)
      result.transaction_id.should == 1890090
      result.name_on_check.should == "Wonkawerks"
      result.timestamp.year.should == 2010
      result.timestamp.month.should == 1
    end
  
    should "parse multiple rows" do
      text = Crack::XML.parse(fixture_file("transaction_search.xml"))
      results = Giact::TransactionResult.from_response(text['string'])
      results.size.should == 4
      results.first.transaction_id.should == 1889756
      results.last.routing_number.should == 320113000
    end
  end
end
