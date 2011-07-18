Before do
  puts "Generic before hook"
end

#Before ('@waat') do
#  puts "*** Before hook for WAAT ***"
##  getInstance("omniture_debugger", "xml")
#  getInstance("http_sniffer", "xml")
#  enableWebAnalyticsTesting
#end

After do
  puts "Generic after hook"
end

#After ('@waat') do
#  puts "*** After hook for WAAT ***"
#  disableWebAnalyticsTesting
#end

