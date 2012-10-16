#**
# * Created by: Anand Bagmar
# * Email: abagmar@gmail.com
# * Date: Dec 29, 2010
# * Time: 9:34:02 AM
# *
# * Copyright 2010 Anand Bagmar (abagmar@gmail.com).  Distributed under the Apache 2.0 License
#**

# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "WAAT"
  gem.homepage = "http://github.com/anandbagmar/WAAT-ruby"
  gem.license = "Apache 2.0"
  gem.summary = %Q{Web Analytics Automation Testing Framework}
  gem.description = %Q{An automated way of testing the Web Analytic tags reported to 'n' number of Web Analytic tools by your product. See here for more details: http://essenceoftesting.blogspot.com/search/label/waat}
  gem.email = "abagmar@gmail.com"
  gem.authors = ["Anand Bagmar"]
  gem.files.exclude "dist/**/*"

  # dependencies defined in Gemfile
#  gem.add_dependency('rjb', ">= 1.3.2")
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :features

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "WAAT-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
