require 'bundler'
require 'selenium-webdriver'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require 'test/unit/assertions'

#
#
#   WAAT configuration
#
#

@waat_src = File.join(File.dirname(__FILE__), "..", "..", "lib", "WAAT")
puts "@WAAT_root_location: #{@waat_src}"
require @waat_src

#   end WAAT configuration

World(Test::Unit::Assertions)
