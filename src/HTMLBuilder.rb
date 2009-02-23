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
require 'Component'
require 'Form'
require 'Control'

module HTMLBuilder
  
  #
  # Parses a YAML tree and returns a list of components.
  #
  def HTMLBuilder.parse(yaml)
    puts yaml.class
    case 
      # If given a string
      when yaml.is_a?(String):
        # If it's a component, load it
        if yaml.is_component?
          return Component.load(yaml)
        # Otherwise, return the string
        else
          return yaml
        end
      
      # If given a list
      when yaml.is_a?(Array):
        # Go through it, parsing its elements
        results = []
        
        yaml.each do |elem|
          results.push parse(elem)
        end
        
        return results
      
      # If given a hash
      when yaml.is_a?(Hash):
        results = {}

        # If there's only one entry in the hash, and it's a component,
        # initialize and return the component
        if yaml.length == 1
          yaml.each do |name, params|
            if( name.is_component? )
              return Component.load(name, parse(params))
            end
          end
        end
        
        # Otherwise, go through each pair in the hash and parse them
        yaml.each do |name, params|
          # If it's a component, load it and store it in the hash as the key,
          # with its name as its value
          if name.is_component?
            component = Component.load(name, parse(params))
            results[component] = name
            
          # Otherwise, parse the value and store it in the hash with the same
          # key
          else
            results[name] = parse(params)
          end
        end
        
        return results
        
      when yaml.is_a?(Object):
        # When given anything else, just return the value
        return yaml
    end
  end
  
  #
  # Parses and renders the given source.
  #
  def HTMLBuilder.render(format, source)
    output = ""
    components = parse(source)
    
    for component in components
      output += component.render(format)
    end
  end
  
end

class String
  def is_component?
    self =~ /^[A-Z]/
  end
end

# Entry point

for arg in ARGV do
  puts "Parsing #{arg}: " + YAML::load_file(arg).inspect
  components = HTMLBuilder::parse( YAML::load_file(arg) )
  puts components.inspect
  for component in components
    puts component.render :xhtml
  end
end


