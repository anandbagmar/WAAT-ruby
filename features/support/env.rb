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

@WAAT_SRC = File.join(File.dirname(__FILE__), "..", "..", "lib", "WAAT")
puts "@WAAT_root_location: #{@WAAT_SRC}"
require @WAAT_SRC

#   end WAAT configuration

World(Test::Unit::Assertions)
