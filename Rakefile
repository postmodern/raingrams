require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/raingrams/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'raingrams'
  gem.version = Raingrams::VERSION
  gem.license = 'MIT'
  gem.summary = %Q{A flexible and general-purpose ngrams library written in Ruby.}
  gem.description = %Q{Raingrams is a flexible and general-purpose ngrams library written in Ruby. Raingrams supports ngram sizes greater than 1, text/non-text grams, multiple parsing styles and open/closed vocabulary models.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/postmodern/raingrams'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
