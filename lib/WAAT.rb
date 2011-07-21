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

  def initialize_waat(web_analytic_tool, input_file_type, keep_loaded_file_in_memory = true, log4j_properties_absolute_file_path = File.join(File.dirname(__FILE__), "WAAT", "resources", "log4j.properties"))
    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO
    @log.info("Initializing WAAT")
    load_java_classes
    @engine_instance = @controller.getInstance(web_analytic_tool(web_analytic_tool), input_file_type(input_file_type), keep_loaded_file_in_memory, log4j_properties_absolute_file_path)
  end

  def enable_web_analytics_testing
    @log.info("Enable Web Analytics Testing")
    @engine_instance.enableWebAnalyticsTesting
  end

  def disable_web_analytics_testing
    @log.info("Disable Web Analytics Testing")
    @engine_instance.disableWebAnalyticsTesting
  end

  def verify_web_analytics_data(test_data_file_name, action_name, url_patterns, minimum_number_of_packets)
    @log.info("Verify Web Analytics Data")
    @log.info("\tTest Data File Name: #{test_data_file_name}")
    @log.info("\tAction Name: #{action_name}")
    java_result = @engine_instance.verifyWebAnalyticsData(test_data_file_name, action_name, url_patterns, minimum_number_of_packets)
    Result.new(java_result)
  end

  private
  def load_java_classes
    separator = (Config::CONFIG['target_os'] =~ /[win|mingw]/) == 0 ? ';' : ':'

    waat_lib_directory = File.join(File.dirname(__FILE__), "WAAT", "lib")
    @log.info("WAAT LIB directory: #{waat_lib_directory}")

    waat_file_list = Dir.glob("#{waat_lib_directory}/*.jar").join(separator)
    @log.info("Loading following JARs: #{waat_file_list}")

    require 'rjb'
    Rjb::load(classpath = waat_file_list,[])

    @web_analytic_tool_reference = Rjb::import('com.thoughtworks.webanalyticsautomation.plugins.WebAnalyticTool')
    @input_file_type_reference = Rjb::import('com.thoughtworks.webanalyticsautomation.inputdata.InputFileType')
    @controller = Rjb::import('com.thoughtworks.webanalyticsautomation.Controller')
    @engine_instance = nil
  end

  def proxy_from_java_enum(java_enum, web_analytic_tool)
    java_enum.values.each do |each_value|
      return each_value if each_value.name==web_analytic_tool.upcase
    end
  end

  def web_analytic_tool(web_analytic_tool)
    proxy_from_java_enum(@web_analytic_tool_reference, web_analytic_tool)
  end

  def input_file_type(input_file_type)
    proxy_from_java_enum(@input_file_type_reference, input_file_type)
  end

end
World(WAAT)