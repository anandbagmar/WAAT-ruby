#**
# * Created by: Anand Bagmar
# * Email: abagmar@gmail.com
# * Date: Dec 29, 2010
# * Time: 9:34:02 AM
# *
# * Copyright 2010 Anand Bagmar (abagmar@gmail.com).  Distributed under the Apache 2.0 License
# *
# * http://essenceoftesting.blogspot.com/search/label/waat
# * http://github.com/anandbagmar/WAAT-Ruby
# * http://github.com/anandbagmar/WAAT
# *
#**

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
