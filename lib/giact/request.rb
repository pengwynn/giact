module Giact
	class Request < ::Weary::Base
	  @gateway = 1
	  
	  def initialize(options={})
	    @company_id ||= Giact.company_id ||= options[:company_id]
	    @username ||= Giact.username ||= options[:username]
      @password ||= Giact.password ||= options[:password]
      @gateway ||= Giact.gateway ||= options[:gateway]
	  end
	  
	  def self.build_uri(method)
      "https://gatewaydtx#{@gateway}.giact.com/RealTime/POST/RealTimeChecks.asmx/#{method}"
    end
	  
	  post "login" do |r|
	    r.url = build_uri("Login")
	    r.requires = [:companyID, :un, :pw]
	  end
	end
end