require 'pathname'
require 'rubygems'

gem 'fakeweb', '>= 1.2.5'

require 'fakeweb'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/giact'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/test/fixtures/' + filename)
  File.read(file_path)
end

def giact_url(url, gateway=1)
  url =~ /^http/ ? url : "https://gatewaydtx#{gateway}.giact.com/RealTime/POST/RealTimeChecks.asmx#{url}"
end

def stub_get(url, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)
  
  FakeWeb.register_uri(:get, giact_url(url), opts)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, giact_url(url), :body => fixture_file(filename))
end

