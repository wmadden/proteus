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
require 'ComponentDefinition'

module HTMLBuilder
  
  #
  # Parses a YAML tree and returns a list of components.
  #
  def HTMLBuilder.parse(yaml)
    case 
      # If given a string
      when yaml.is_a?(String):
        # If it's a component, load it
        if is_component?(yaml)
          return load_component(yaml, nil)
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
            if( is_component?(name) )
              return load_component(name, parse(params))
            end
          end
        end
        
        # Otherwise, go through each pair in the hash and parse them
        yaml.each do |name, params|
          # If it's a component, load it and store it in the hash as the key,
          # with its name as its value
          if is_component?(name)
            component = load_component(name, parse(params))
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
  # Loads a component given its kind and YAML node value.
  #
  def HTMLBuilder.load_component(kind, value)
    definition = ComponentDefinition.load(kind)
    
    # If there's no definition, return the value
    if definition.nil?
      return value
    end
    
    # Otherwise, interpret its children and instantiate the component
    case
      when value.is_a?(Hash):
        definition.instantiate(value)

      when value.is_a?(Array):
        definition.instantiate({}, value)

      when value.nil?:
        definition.instantiate()
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
  
  #
  # Returns true if argument is a component string.
  #
  def HTMLBuilder.is_component?(str)
    str =~ /^[A-Z]/
  end
end

class Object
  def render(format = :xhtml)
    to_s
  end
end

class Array
  def render(format = :xhtml)
    inject("") {|output, elem| output += elem.render}
  end
end

class Hash
  def render(format = :xhtml)
    inject("") do |output, name, value|
      if name.is_a? Component
        output += name.render
      else
        output += value.render
      end
    end
  end
end

# Entry point

for arg in ARGV do
  #puts "Parsing #{arg}: #{arg}"
  
  components = HTMLBuilder::parse( YAML::load_file(arg) )
  
  puts components.render(:xhtml)
end


