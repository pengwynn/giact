require 'rubygems'
require 'time'
gem 'activesupport', '~> 2.3.2'
require 'activesupport'

gem 'hashie', '~> 0.1.3'
require 'hashie'

gem 'httparty', '>= 0.5.0'
require 'httparty'

gem 'validatable', '~> 1.6.7'
require 'validatable'


directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

class Hash
 
  # Converts all of the keys to strings, optionally formatting key name
  def camelize_keys!
    keys.each{|k|
      v = delete(k)
      new_key = k.to_s.camelize.gsub(/Id/, "ID")
      self[new_key] = v
      v.camelize_keys! if v.is_a?(Hash)
      v.each{|p| p.camelize_keys! if p.is_a?(Hash)} if v.is_a?(Array)
    }
    self
  end
 
end

module Giact
  
  class GiactError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super
    end
  end

  class Unauthorized      < StandardError; end
  class InvalidRequest    < GiactError; end
  
  # config/initializers/giact.rb (for instance)
  # 
  # Giact.configure do |config|
  #   config.company_id =  'your_company_id'
  #   config.username = 'your_api_username'
  #   config.password = 'your_api_password'
  # end
  def self.configure
    yield self
    
    Giact.company_id = company_id
    Giact.username = username
    Giact.password = password
    true
  end
  
  def self.company_id
    @company_id
  end
  
  def self.company_id=(company_id)
    @company_id = company_id
  end
  
  def self.username
    @username
  end
  
  def self.username=(username)
    @username = username
  end
  
  def self.password
    @password
  end
  
  def self.password=(password)
    @password = password
  end
  
  def self.test_mode?
    @test_mode || false
  end
  
  def self.test_mode=(test_mode)
    @test_mode = test_mode
  end
end

require File.join(directory, 'giact', 'cancel_recurring_check_list')
require File.join(directory, 'giact', 'recurring_check_list')
require File.join(directory, 'giact', 'transaction_result')
require File.join(directory, 'giact', 'payment_reply')
require File.join(directory, 'giact', 'payment_request')
require File.join(directory, 'giact', 'installment_payment_request')
require File.join(directory, 'giact', 'recurring_payment_request')
require File.join(directory, 'giact', 'client')