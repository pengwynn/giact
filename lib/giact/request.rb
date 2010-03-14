module Giact
	class Request < ::Weary::Base
	  
	  def initialize(options={})
	    @company_id ||= Giact.company_id ||= options[:company_id]
	    @username ||= Giact.username ||= options[:username]
      @password ||= Giact.password ||= options[:password]
      @gateway ||= Giact.gateway ||= options[:gateway]
	  end
	  
		format :xml
	
	  def self.build_uri(method)
      "https://gatewaydtx#{@gateway}.giact.com/RealTime/POST/RealTimeChecks.asmx/#{method}"
    end
	  
		def self.request(operation, params={})
			Weary.request("https://gatewaydtx1.giact.com/RealTime/POST/RealTimeChecks.asmx/#{operation}", :post) do |req|
				req.with = params unless params.blank?
			end
		end
		
		# we have to use our own parser due to Weary's :format option mingling with the req.url
		def self.parse(response, key=nil)
			res = Crack::XML.parse(response.body)
			unless key.nil? && res[key]
				res[key]
			else
				res
			end
		end
		
		# public methods
		def request(operation, params={})
			self.class.request(operation, params)
		end

		def parse(response, key=nil)
			self.class.parse(response, key)
		end
	end
end