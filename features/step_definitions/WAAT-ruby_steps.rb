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

require 'selenium-webdriver'

Given /^I navigate to Anand Bagmar's blog$/ do
  url_patterns = ["GET /ps/ifr?container=friendconnect&mid=0"]
  action_name = "OpenWAATArticleOnBlog_HttpSniffer"
  test_data_file_name = File.join(File.dirname(__FILE__), "..", "..", "sampleData", "TestData.xml")

#  initialize_waat()
#
#  enable_web_analytics_testing

  url = "http://essenceoftesting.blogspot.com"
  @driver = Selenium::WebDriver.for :firefox
  @driver.get url

  params = [:test_data_file_name=> test_data_file_name, :action_name => action_name, :url_patterns => url_patterns, :minimum_number_of_packets => 1]
  result = verify_web_analytics_data(params)

  puts "->#{result.status}"
  assert (result.status=="FAIL"), "Incorrect Verification Status. Expected: 'FAIL', Actual: #{result.status}"
  assert (result.list_of_errors.size==14), "Incorrect number of errors. Expected: '14', Actual: #{result.list_of_errors.size}"
  result.list_of_errors.each do |err|
    puts "->\t#{err}"
  end

#  disable_web_analytics_testing
end