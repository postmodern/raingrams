require 'rubygems'
require 'rake'
require './lib/raingrams/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'raingrams'
    gem.version = Raingrams::VERSION
    gem.license = 'MIT'
    gem.summary = %Q{A flexible and general-purpose ngrams library written in Ruby.}
    gem.description = %Q{Raingrams is a flexible and general-purpose ngrams library written in Ruby. Raingrams supports ngram sizes greater than 1, text/non-text grams, multiple parsing styles and open/closed vocabulary models.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/postmodern/raingrams'
    gem.authors = ['Postmodern']
    gem.add_dependency 'nokogiri', '~> 1.4.1'
    gem.add_development_dependency 'rspec', '~> 1.3.0'
    gem.add_development_dependency 'yard', '~> 0.5.3'
    gem.has_rdoc = 'yard'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
end

end
