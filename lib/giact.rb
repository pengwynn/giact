require 'rubygems'
require 'time'

gem 'activesupport', '~> 2.3.2'
require 'active_support'

gem 'hashie', '~> 0.1.3'
require 'hashie'

gem 'validatable', '~> 1.6.7'
require 'validatable'

gem 'weary', '>= 0.7.2'
require 'weary'

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

  class Unauthorized   < StandardError; end
  class InvalidRequest < GiactError;    end
  
  # config/initializers/giact.rb (for instance)
  # 
  # Giact.configure do |config|
  #   config.company_id =  'your_company_id'
  #   config.username = 'your_api_username'
  #   config.password = 'your_api_password'
  # end
  def self.configure
    yield self
    true
  end
  
  def self.test_mode?
    @test_mode || false
  end
  
  class << self
    attr_accessor :company_id
    attr_accessor :username
    attr_accessor :password
    attr_accessor :gateway
    attr_accessor :test_mode
  end
end

require File.join(directory, 'giact', 'request')

require File.join(directory, 'giact', 'request', 'payment')
require File.join(directory, 'giact', 'request', 'recurring_payment')
require File.join(directory, 'giact', 'request', 'installment_payment')
require File.join(directory, 'giact', 'request', 'refund')
require File.join(directory, 'giact', 'request', 'partial_refund')
require File.join(directory, 'giact', 'request', 'daily_stats')
require File.join(directory, 'giact', 'request', 'range_report')

require File.join(directory, 'giact', 'reply', 'payment')
require File.join(directory, 'giact', 'reply', 'recurring')
require File.join(directory, 'giact', 'reply', 'installments')
require File.join(directory, 'giact', 'reply', 'cancel')
require File.join(directory, 'giact', 'reply', 'refund')
require File.join(directory, 'giact', 'reply', 'search')

require File.join(directory, 'giact', 'reply', 'daily', 'summary')
require File.join(directory, 'giact', 'reply', 'daily', 'deposits')
require File.join(directory, 'giact', 'reply', 'daily', 'returns')
require File.join(directory, 'giact', 'reply', 'daily', 'refunds')
require File.join(directory, 'giact', 'reply', 'daily', 'errors_or_scrubs')

require File.join(directory, 'giact', 'reply', 'report', 'returns')
require File.join(directory, 'giact', 'reply', 'report', 'refunds')


require File.join(directory, 'giact', 'client')