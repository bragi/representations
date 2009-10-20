require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "representations"
    gemspec.summary = "Changes syntax of rails helpers and form builders to object oriented and model specific"
    gemspec.description = "Rails helpers, including form builders are great to allow rapid development of applications and views.  
They are procedural in nature and have hard time to adapt to complex models. They also live in a single namespace making it difficult to find which helpers apply to which models.  
Resource representations change syntax to object oriented and model specific."
    gemspec.email = "skimos00@gmail.com"
    gemspec.homepage = "http://github.com/bragi/representations"
    gemspec.authors = ["Łukasz Piestrzeniewicz", "Adam Sokolnicki"]
    gemspec.files = [
    ".document",
     "LICENSE.txt",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "init.rb",
     "lib/representations.rb",
     "lib/view_helpers.rb",
     "rails/init.rb",
     "representations.gemspec"
  ]
    gemspec.test_files.exclude('spec/**/*')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/test_application/spec/helpers/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/test_application/spec/helpers/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "representations #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
