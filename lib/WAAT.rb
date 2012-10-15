#**
# * Created by: Anand Bagmar
# * Email: abagmar@gmail.com
# * Date: July 20, 2011
# * Time: 9:34:00 AM
# *
# * Copyright 2010 Anand Bagmar (abagmar@gmail.com).  Distributed under the Apache 2.0 License
# *
# * http://essenceoftesting.blogspot.com/search/label/waat
# * http://github.com/anandbagmar/WAAT-Ruby
# * http://github.com/anandbagmar/WAAT
# *
#**

module WAAT

  #
  # Result class converts the Result object returned by WAAT-Java to a Ruby class
  #
  # This class has 2 methods
  # * status          => PASS | FAIL | SKIP
  # * list_of_errors  => An array of strings containing all the Web Analytic validation errors as returned by the verify_web_analytics_data method
  #

  class Result
    attr_reader :status, :list_of_errors

    def initialize(java_result)
      @status = java_result.getVerificationStatus.name
      @list_of_errors = []
      java_result.getListOfErrors.toArray.each do |each_error|
        @list_of_errors << each_error.toString
      end
    end
  end

  #
  # === Synopsis
  # This method initializes 'WAAT-Ruby'
  #
  # === Args
  # This takes a hash as an input with the following possible name/value pairs

  # {
  #   *:keep_loaded_file_in_memory* => Default: true,
  #   *:waat_plugin* => Default: "http_sniffer",
  #   *:input_file_type* => Default: "xml", (Currently the only supported file type)
  #   *:log4j_properties_absolute_file_path => Default: File.join(File.dirname(__FILE__), "WAAT", "resources", "log4j.properties")}

  # keep_loaded_file_in_memory: This means the loaded test data file will be kept in memory till the tests are running.
  # waat_plugin: http_sniffer or js_sniffer
  #
  # === Examples:
  #
  # * initialize_waat        => This will use the default value for keep_loaded_file_in_memory, and will use the http_sniffer
  # * initialize_waat(:keep_loaded_file_in_memory => true)  => Uses http_sniffer by default
  # * initialize_waat(:keep_loaded_file_in_memory => false, :waat_plugin => "js_sniffer") => This will unload the test data file after the Web Analytic tags verification is done AND uses js_sniffer as the web analytic plugin
  #
  # === Corresponding WAAT-Java API
  # getInstance(WebAnalyticTool, InputFileType, keepLoadedFileInMemory, log4jPropertiesFilePath)::
  #      This method initializes WAAT-Java.
  #      Unlike WAAT-Java, WAAT-Ruby supports the http_sniffer & js_sniffer mechanism for doing Web Analytics testing.
  #      Also, WAAT-Ruby supports specification of the input test data in XML format only.
  #
  #
  def initialize_waat(init_params={})
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
    logger.info("Initializing WAAT")
    load_java_classes
    engine_instance(init_params)
  end

  #
  # === Synopsis
  # This method enables Web Analytic testing for all subsequent tests till it is explicitly disabled
  # This is applicable ONLY WHEN USING HTTP_SNIFFER
  #
  # === Corresponding WAAT-Java API
  # enableWebAnalyticsTesting::
  #      This method enables Web Analytic testing in WAAT-Java
  #      When this method is called, the packet capturing is started on all the network interfaces on the machine where the tests are running.
  #
  def enable_web_analytics_testing
    logger.info("Enable Web Analytics Testing")
    engine_instance.enableWebAnalyticsTesting
  end

  #
  # === Synopsis
  # This method disables Web Analytic testing for all subsequent tests till it is explicitly enabled again
  # This is applicable ONLY WHEN USING HTTP_SNIFFER
  #
  # === Corresponding WAAT-Java API
  # disableWebAnalyticsTesting::
  #      This method disables Web Analytic testing in WAAT-Java
  #      When this method is called, the packet capturing is stopped for all the network interfaces on the machine where the tests are running.
  #
  def disable_web_analytics_testing
    logger.info("Disable Web Analytics Testing")
    engine_instance.disableWebAnalyticsTesting
  end

  #
  # === Synopsis
  # This method verifies the Web Analytic tags using the http_sniffer mechanism
  #
  # === Args
  # params Hash with the following entries
  #
  # *:test_data_file_name*:
  # Absolute path to the input Test Data (xml) file name.
  #
  # *:action_name*:
  # A (String) name representing the action done in the UI, for which we want to do Web Analytics Testing.
  # This action_name matches the corresponding name in the test_data_file_name
  #
  # *:url_patterns*:
  # An array of Strings containing URL snippets that will be used to filter the packets captured by HttpSniffer
  #
  # *:minimum_number_of_packets*:
  # The minimum number of "filtered" packets to capture based on the url_patterns provided
  # *This is applicable ONLY WHEN USING HTTP_SNIFFER*
  #
  # === Examples:
  #
  # * verify_web_analytics_data({:test_data_file_name, :action_name, :url_patterns, :minimum_number_of_packets}) => This will enable Web Analytic Testing
  #   where:
  #     :test_data_file_name         => File.join(File.dirname(__FILE__), "..", "..", "sampleData", "TestData.xml")
  #     :action_name                 => "OpenWAATArticleOnBlog_HttpSniffer"
  #     :url_patterns                => ["GET /ps/ifr?container=friendconnect&mid=0"]
  #     :minimum_number_of_packets   => 1
  #
  # === Corresponding WAAT-Java API
  # verifyWebAnalyticsData(test_data_file_name, action_name, url_patterns, minimum_number_of_packets)::
  #      This method enables Web Analytic testing in WAAT-Java
  #      When this method is called, the packet capturing is started on all the network interfaces on the machine where the tests are running.
  #
  def verify_web_analytics_data(params)
    logger.info("Verify Web Analytics Data with params: #{params.inspect}")
    logger.info("\tTest Data File Name: #{params[:test_data_file_name]}")
    logger.info("\tAction Name: #{params[:action_name]}")

    if(@waat_plugin_type.upcase=="HTTP_SNIFFER")
      java_result = @engine_instance.verifyWebAnalyticsData(params[:test_data_file_name], params[:action_name], params[:url_patterns], params[:minimum_number_of_packets])
    else
      java_result = @engine_instance.verifyWebAnalyticsData(params[:test_data_file_name], params[:action_name], params[:url_patterns])
    end

    Result.new(java_result)
  end

  private
  def logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger
  end

  def engine_instance(init_params={})
    waat_defaults = {:keep_loaded_file_in_memory => true,
                     :waat_plugin => "http_sniffer",
                     :input_file_type => "xml",
                     :log4j_properties_absolute_file_path => File.join(File.dirname(__FILE__), "WAAT", "resources", "log4j.properties")}

    init_params = waat_defaults.merge(symbolize_keys(init_params))
    @engine_instance ||=  controller.getInstance(
        web_analytic_tool(init_params[:waat_plugin]),
        input_file_type(init_params[:input_file_type]),
        init_params[:keep_loaded_file_in_memory],
        init_params[:log4j_properties_absolute_file_path])
  end

  def controller
    @controller ||= Rjb::import('com.thoughtworks.webanalyticsautomation.Controller')
  end

  def input_file_type_reference
    @input_file_type_reference ||= Rjb::import('com.thoughtworks.webanalyticsautomation.inputdata.InputFileType')
  end

  def web_analytic_tool_reference
    @web_analytic_tool_reference ||= Rjb::import('com.thoughtworks.webanalyticsautomation.plugins.WebAnalyticTool')
  end

  def load_java_classes
    separator = (Config::CONFIG['target_os'] =~ /[win|mingw]/) == 0 ? ';' : ':'

    waat_lib_directory = File.join(File.dirname(__FILE__), "WAAT", "lib")
    logger.info("WAAT LIB directory: #{waat_lib_directory}")

    waat_file_list = Dir.glob("#{waat_lib_directory}/*.jar").join(separator)
    logger.info("Loading following JARs: #{waat_file_list}")

    require 'rjb'
    Rjb::load(classpath = waat_file_list,[])
  end

  def proxy_from_java_enum(java_enum, java_enum_value)
    java_enum.values.each do |each_value|
      return each_value if each_value.name==java_enum_value.upcase
    end
  end

  def web_analytic_tool(waat_plugin)
    @waat_plugin_type = waat_plugin
    proxy_from_java_enum(web_analytic_tool_reference, waat_plugin)
  end

  def input_file_type(input_file_type)
    proxy_from_java_enum(input_file_type_reference, input_file_type)
  end

  def symbolize_keys(hash)
    hash.keys.each do |key|
      hash[(key.to_sym rescue key) || key ] = hash.delete(key)
    end
    hash
  end
end
World(WAAT)