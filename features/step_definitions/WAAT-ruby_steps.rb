require 'selenium-webdriver'

Given /^I navigate to Anand Bagmar's blog$/ do
#  urlPatterns = ["GET /ps/ifr?container=friendconnect&mid=0"]
#  actionName = "OpenWAATArticleOnBlog_HttpSniffer"
#  inputDataFileName = File.dirname(__FILE__) + "/../../sampleData/TestData.xml"

#  getInstance("omniture_debugger", "xml")
#  getInstance("http_sniffer", "xml")
#
#  enableWebAnalyticsTesting

  url = "http://essenceoftesting.blogspot.com"
  driver = Selenium::WebDriver.for :firefox
  driver.get url

#  result = verifyWebAnalyticsData(inputDataFileName, actionName, urlPatterns, 1)
#
#  puts "->#{result.status}"
#  assert (result.status=="FAIL"), "Incorrect Verification Status. Expected: 'FAIL', Actual: #{result.status}"
#  assert (result.list_of_errors.size==14), "Incorrect number of errors. Expected: '14', Actual: #{result.list_of_errors.size}"
#  result.list_of_errors.each do |err|
#    puts "->\t#{err}"
#  end

#  disableWebAnalyticsTesting
  driver.quit
end