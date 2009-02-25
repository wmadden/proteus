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
      when is_scalar?(yaml):
        load_component(yaml)
      
      # If given a list
      when yaml.is_a?(Array):
        # Map list to a list of components
        yaml.map { |elem| load_component(elem) }
        
      # If given a hash
      when yaml.is_a?(Hash):
        # TODO: come up with better syntax for this
        if yaml.length == 1 and component_string?(yaml.to_a[0][0])
          load_component(yaml.to_a[0][0], yaml.to_a[0][1])
        else
          yaml.inject({}) { |acc, elem| acc[elem[0]] = parse(elem[1]) }
        end
    end
  end
  
  #
  # Returns if the given string is a valid component name.
  #
  def HTMLBuilder.component_name?(string)
    # Valid if starts with uppercase and only contains alpha characters and _
    string =~ /[A-Z][a-zA-Z_]*/
  end
  
  protected
  
  #
  # Returns true if the value is a scalar.
  #
  def HTMLBuilder.is_scalar?(value)
    not (value.is_a?(Array) || value.is_a?(Hash))
  end
  
  #
  # Loads a component given its kind and YAML node value.
  #
  def HTMLBuilder.load_component(kind, value = nil)
    # If the kind is not a valid component name or we can't find the definition
    if not (component_name?(kind) and definition = ComponentDefinition.load(kind))
      if value
        # If we're given a value, fail, we don't know what to do
        throw "Malformed input"
      else
        return kind
      end
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

# Entry point

for arg in ARGV do
  #puts "Parsing #{arg}: #{arg}"
  
  components = HTMLBuilder::parse( YAML::load_file(arg) )
  
  puts components.render(:xhtml)
end

