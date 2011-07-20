Before do
  puts "Generic before hook"
end

Before ('@waat') do
  puts "*** Before hook for WAAT ***"
#  initialize_waat("omniture_debugger", "xml")
  initialize_waat("http_sniffer", "xml")
  enable_web_analytics_testing
end

After do
  puts "Generic after hook"
  @driver.quit
end

After ('@waat') do
  puts "*** After hook for WAAT ***"
  disable_web_analytics_testing
end

