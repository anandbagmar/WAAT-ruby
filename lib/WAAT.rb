module WAAT

  class Result
    attr_accessor :status, :list_of_errors

    def initialize(java_result)
      @status = java_result.getVerificationStatus.name
      @list_of_errors = []
      java_result.getListOfErrors.toArray.each do |each_error|
        @list_of_errors << each_error.toString
      end
    end
  end

  def loadJavaClasses
    separator = (Config::CONFIG['target_os'] =~ /[win|mingw]/) == 0 ? ';' : ':'

    @WAAT_LIB = File.dirname(__FILE__) + "/../lib"
    puts "@WAAT_LIB: #{@WAAT_LIB}"

    waat_file_list = [".",
          @WAAT_LIB + "/WAAT_v1.3.jar",
          @WAAT_LIB + "/log4j-1.2.16.jar",
          @WAAT_LIB + "/jpcap.jar",
          @WAAT_LIB + "/xstream-1.3.1.jar",
          @WAAT_LIB + "/commons-lang-2.3.jar"].join(separator)

#    puts "waat_file_list: " + waat_file_list.to_s

    require 'rjb'
    Rjb::load(classpath = waat_file_list,[])

    @WebAnalyticTool = Rjb::import('com.thoughtworks.webanalyticsautomation.plugins.WebAnalyticTool')
    @InputFileType = Rjb::import('com.thoughtworks.webanalyticsautomation.inputdata.InputFileType')
    @Controller = Rjb::import('com.thoughtworks.webanalyticsautomation.Controller')
    @engine_instance = nil
  end

  def getMatchingProxyFromJavaEnum(javaEnumClass, webAnalyticTool)
    webAnalyticToolProxy = nil
    javaEnumClass.values.each do |eachValue|
      puts "Evaluating: " + eachValue.name + " with: " + webAnalyticTool.upcase
      if (eachValue.name==webAnalyticTool.upcase)
        webAnalyticToolProxy = eachValue
        puts "Proxy match found"
        break
      end
    end
    webAnalyticToolProxy
  end

  def getWebAnalyticTool(webAnalyticTool)
    webAnalyticToolProxy = getMatchingProxyFromJavaEnum(@WebAnalyticTool, webAnalyticTool)
    return webAnalyticToolProxy
  end

  def getInputFileType(inputFileType)
    inputFileTypeProxy = getMatchingProxyFromJavaEnum(@InputFileType, inputFileType)
    return inputFileTypeProxy
  end

  def getInstance(webAnalyticTool, inputFileType, keepLoadedFileInMemory = true, log4jPropertiesAbsoluteFilePath = File.dirname(__FILE__) + "/../resources/log4j.properties")
    loadJavaClasses
    @engine_instance = @Controller.getInstance(getWebAnalyticTool(webAnalyticTool), getInputFileType(inputFileType), true, log4jPropertiesAbsoluteFilePath)
#    puts "engine_instance: " + @engine_instance.inspect
  end

  def enableWebAnalyticsTesting
#    puts "enableWebAnalyticsTesting"
    @engine_instance.enableWebAnalyticsTesting
  end

  def disableWebAnalyticsTesting
#    puts "disableWebAnalyticsTesting"
    @engine_instance.disableWebAnalyticsTesting
  end

  def verifyWebAnalyticsData(testDataFileName, actionName, urlPatterns, minimumNumberOfPackets)
#    puts "verifyWebAnalyticsData"
    java_result = @engine_instance.verifyWebAnalyticsData(testDataFileName, actionName, urlPatterns, minimumNumberOfPackets)
    return Result.new(java_result)
  end
end
World(WAAT)