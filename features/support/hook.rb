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

Before do
  puts "Generic before hook"
end

Before ('@waat') do
  puts "*** Before hook for WAAT ***"
  initialize_waat()
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

