#!/usr/bin/ruby
################################################################################
# HTMLBuilder.rb
#
# Defines the static class HTMLBuilder, used to load Components from YAML
# source.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require 'yaml'
require 'Component.rb'

class HTMLBuilder

  #
  # Parses text and returns the resultant components.
  #
  def parse(source)
    YAML::parse(source)
  end

  
  #
  # Parses and renders the given source.
  #
  def render(format, source)
    output = ""
    components = parse(source)
    
    for component in components
      output += component.render(format)
    end
  end
  
end

# Entry point
h = HTMLBuilder.new

for arg in ARGV do
  puts "Parsing #{arg}"
  puts h.parse( File.open(arg) ).to_yaml
end
