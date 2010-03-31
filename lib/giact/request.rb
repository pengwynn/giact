require "json/pure"

module Giact
  class Request
    # @param [Hash] options method options
    # @option options [Integer] :gateway Number (1-3) of gateway server to use
    # @option options [String] :company_id Your Giact company ID
    # @option options [String] :username Your Giact API username
    # @option options [String] :password Your Giact API password
    def initialize(options={})
      @company_id ||= Giact.company_id ||= options[:company_id]
      @username ||= Giact.username ||= options[:username]
      @password ||= Giact.password ||= options[:password]
      @gateway ||= Giact.gateway ||= options[:gateway]
    end
    
    # Our base level request method.
    # @option operation [String] The API method you wish to call
    # @option params [Mixed] The arguments for the request
    def self.post(operation, params={})
      Weary.post("https://gatewaydtx1.giact.com/RealTime/POST/RealTimeChecks.asmx/#{operation}") do |req|
        req.with = params unless params.blank?
      end
    end
    
    # we have to use our own parser due to Weary's :format option mingling with the req.url
    # @option response [String] The response from a Giact::Request#post
    # @return [String] The response string
    def self.parse(response)
      res = Crack::XML.parse(response.body)
      unless res.empty? && res.include?("string")
        res["string"]
      else
        false
      end
    end
    
    # public methods
    def post(operation, params={})
      self.class.post(operation, params)
    end

    def parse(response)
      self.class.parse(response)
    end
  end
end