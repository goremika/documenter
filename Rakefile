require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "documenter"
    gem.summary = %Q{api to some tools to work with documetns}
    gem.description = %Q{This gem uses OpenOffice and pdftk to convert, split, join, fill and copy files. It may be usefull if you have many documents to work with. It is not realy fast solution and it depend on istalled software}
    gem.email = "goremika@gmail.com"
    gem.homepage = "http://github.com/goremika/documenter"
    gem.authors = ["A N"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "rubyzip", ">= 0"
    gem.add_dependency "hpricot", ">= 0.8.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "documenter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
