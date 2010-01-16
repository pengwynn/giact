require 'helper'

class TestGiact < Test::Unit::TestCase
  context "when using the Giact API" do
    setup do
      @client = Giact::Client.new(:company_id => 1976, :username => 'pengwynn', :password => 'OU812')
    end

    should "be able to log in" do
      stub_post("/Login", "login.xml")
      token = @client.login
      token.should == 'f7edf569-e946-45d0-82b0-5ee44e3c027d'
    end
    
    should "retreive an auth token implicitly" do
      stub_post("/Login", "login.xml")
      token = @client.token
      token.should == 'f7edf569-e946-45d0-82b0-5ee44e3c027d'
    end
    
    should "raise an error when failing to authenticate" do
      stub_post("/Login", "login_failed.txt")
      assert_raise Giact::Unauthorized do
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
        result = @client.recurring_payments(@request)
        
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
          result = @client.installments_payments(@request)
        end
      end
      
      should "process installments payments" do
        stub_post("/InstallmentsPayments", "payment_pass.xml")
        result = @client.installments_payments(@request)
        
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
      @payment_request.to_request_hash['Amount'].should == "30.40"
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
      @payment_request.to_request_hash['Amount'].should == "30.40"
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
  
  should_eventually "list recurring checks for an order ID" do
    
  end
  
  should_eventually "list recurring checks for a transaction ID" do
    
  end
  
  should_eventually "cancel future recurring checks by order ID" do
    
  end
  
  should_eventually "cancel future recurring checks by transaction ID" do
    
  end
  
  should_eventually "list installment checks by order ID" do
    
  end
  
  should_eventually "list installment checks by transaction ID" do
    
  end
  
  should_eventually "cancel future installment checks by order ID" do
    
  end
  
  should_eventually "cancel future installment checks by transaction ID" do
    
  end
  
  should_eventually "cancel a transaction by order ID that has not been batched" do
    
  end
  
  should_eventually "cancel a transaction by transaction ID that has not been batched" do
    
  end
  
  should_eventually "request a refund by order ID" do
    
  end
  
  should_eventually "request a refund by transaction ID" do
    
  end
  
  should_eventually "request a partial refund by order ID" do
    
  end
  
  should_eventually "request a partial refund by transaction ID" do
    
  end
  
  should_eventually "return a daily summary" do
    
  end
  
  should_eventually "list daily deposits for a given date" do
    
  end
  
  should_eventually "list checks returned for a given date" do
    
  end
  
  should_eventually "list checks refunded for a given date" do
    
  end
  
  should_eventually "list transactions scrubbed for a given date" do
    
  end
  
  should_eventually "list errored transactions for a given date" do
    
  end
  
  should_eventually "list checks returned for a given date range" do
    
  end
  
  should_eventually "list checks refunded for a given date range" do
    
  end
  
  should_eventually "search transactions by order ID" do
    
  end
  
  should_eventually "search transactions by customer ID" do
    
  end
  
  should_eventually "search transactions by name on check" do
    stub_post("/TransactionsByNameOnCheck", "transaction_search.xml")
    results = @client.search_transactions(:name_on_check => "Willy Wonka")
    results.first.transaction_id.should = 1889756
    results.first.address_line_1.should == '1313 MOCKINGBIRD LANE'
    
    results.last.transaction_id.should == 1890090
    results.last.is_recurring?.should == true
    results.last.recurring_frequency.should == 'monthly'
  end
end
