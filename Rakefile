# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './lib/raingrams/version.rb'

Hoe.new('raingrams', Raingrams::VERSION) do |p|
  p.rubyforge_name = 'raingrams'
  p.developer('Postmodern', 'postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs'
  p.extra_deps = [['nokogiri', '>=1.2.0']]
end

# vim: syntax=Ruby
