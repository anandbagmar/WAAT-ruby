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

Given /^I navigate to Anand Bagmar's blog - HttpSniffer$/ do
  url_patterns = ["GET /ps/ifr?container=friendconnect&mid=0"]
  action_name = "OpenWAATArticleOnBlog_HttpSniffer"
  test_data_file_name = File.join(File.dirname(__FILE__), "..", "..", "sampleData", "TestData.xml")

  initialize_waat(:waat_plugin => "http_sniffer")
  enable_web_analytics_testing

  url = "http://essenceoftesting.blogspot.com"
  @driver = Selenium::WebDriver.for :firefox
  @driver.get url

  params = {:test_data_file_name=> test_data_file_name, :action_name => action_name, :url_patterns => url_patterns, :minimum_number_of_packets => 1}
  result = verify_web_analytics_data(params)

  puts "->#{result.status}"
  assert (result.status=="FAIL"), "Incorrect Verification Status. Expected: 'FAIL', Actual: #{result.status}"
  assert (result.list_of_errors.size==14), "Incorrect number of errors. Expected: '14', Actual: #{result.list_of_errors.size}"
  result.list_of_errors.each do |err|
    puts "->\t#{err}"
  end

  disable_web_analytics_testing
end

Given /^I navigate to some page - JsSniffer$/ do
  base_url = "https://www.mirena.com/en/privacy_statement_user.php"

  test_data_file_name = File.join(File.dirname(__FILE__), "..", "..", "sampleData", "TestData.xml")
  action_name = "OpenAMirenaSecureSite_JsSniffer"

  JS_FOR_MIRENA_SITE = "window.WAAT_URL=\"\";window.WebTrends.prototype.dcsTag=function(){if(document.cookie.indexOf(\"WTLOPTOUT=\")!=-1){return}var WT=this.WT;var DCS=this.DCS;var DCSext=this.DCSext;var i18n=this.i18n;var P=\"http\"+(window.location.protocol.indexOf('https:')==0?'s':'')+\"://\"+this.domain+(this.dcsid==\"\"?'':'/'+this.dcsid)+\"/dcs.gif?\";if(i18n){WT.dep=\"\"}for(var N in DCS){if(DCS[N]&&(typeof DCS[N]!=\"function\")){P+=this.dcsA(N,DCS[N])}}for(N in WT){if(WT[N]&&(typeof WT[N]!=\"function\")){P+=this.dcsA(\"WT.\"+N,WT[N])}}for(N in DCSext){if(DCSext[N]&&(typeof DCSext[N]!=\"function\")){if(i18n){WT.dep=(WT.dep.length==0)?N:(WT.dep+\";\"+N)}P+=this.dcsA(N,DCSext[N])}}if(i18n&&(WT.dep.length>0)){P+=this.dcsA(\"WT.dep\",WT.dep)}if(P.length>2048&&navigator.userAgent.indexOf('MSIE')>=0){P=P.substring(0,2040)+\"&WT.tu=1\"}this.dcsCreateImage(P);window.WAAT_URL=P;this.WT.ad=\"\"};_tag.dcsCustom=function(){}; _tag.DCS.dcscfg=\"1\"; _tag.dcsCollect();return window.WAAT_URL"

  initialize_waat(:waat_plugin => "js_sniffer")

  @driver = Selenium::WebDriver.for :firefox
  @driver.get base_url

  extracted_url = extract_url_from_javascript(JS_FOR_MIRENA_SITE);

  params = {:test_data_file_name=> test_data_file_name, :action_name => action_name, :url_patterns => extracted_url}
  result = verify_web_analytics_data(params)

  puts "->#{result.status}"
  assert (result.status=="FAIL"), "Incorrect Verification Status. Expected: 'FAIL', Actual: #{result.status}"
  assert (result.list_of_errors.size==14), "Incorrect number of errors. Expected: '14', Actual: #{result.list_of_errors.size}"
  result.list_of_errors.each do |err|
    puts "->\t#{err}"
  end
end

def extract_url_from_javascript(javascript)
  @driver.execute_script(javascript)
end
