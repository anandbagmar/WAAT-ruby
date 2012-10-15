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

Feature: Check if tags are reported when my blog page is opened

  @waat
  Scenario: Tags reported on loading blog page - HttpSniffer
    Given I navigate to Anand Bagmar's blog - HttpSniffer

  Scenario: Tags reported on loading blog page - JsSniffer
    Given I navigate to some page - JsSniffer