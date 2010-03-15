module Giact
  class Request < ::Weary::Base
    
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
    def self.request(operation, params={})
      Weary.request("https://gatewaydtx1.giact.com/RealTime/POST/RealTimeChecks.asmx/#{operation}", :post) do |req|
        req.with = params unless params.blank?
      end
    end
    
    # we have to use our own parser due to Weary's :format option mingling with the req.url
    def self.parse(response, key="string")
      res = Crack::XML.parse(response.body)
      unless key.empty? && res[key]
        res[key]
      else
        res
      end
    end
    
    # public methods
    def request(operation, params={})
      self.class.request(operation, params)
    end

    def parse(response, key="string")
      self.class.parse(response, key)
    end
  end
end