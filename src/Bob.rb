#!/usr/bin/ruby
################################################################################
# Bob.rb
#
# Defines the static class Bob, used to load Components from YAML
# source.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require 'yaml'
require 'Component'
require 'ComponentDefinition'

module Bob
  
  @@path = ComponentDefinition::DEFAULT_PATH
  
  # Define exception type
  class UnknownComponent < Exception
  end
  
  def self.path=(value)
    @@path = value
  end
  
  def self.path
    @@path
  end
  
  #
  # Loads a file, given its name, and parses the contents.
  #
  def self.load(file)
    parse(YAML.load_file(file))
  end
  
  #
  # Parses a YAML tree and returns a list of components.
  #
  def self.parse(yaml)
    case 
      # If given a list
      when yaml.is_a?(Array):
        # Map list to a list of components
        return yaml.map { |elem| parse(elem) }
        
      # If given a hash
      when yaml.is_a?(Hash):
        if yaml.length == 1 and yaml.keys.first.component_name?
          value = parse(yaml.values.first)
          
          begin
            return load_component(yaml.keys.first, value)
          rescue Bob::UnknownComponent
            return {yaml.keys.first => value}
          end
        else
          return yaml.inject({}) do |acc, pair|
              acc[pair[0]] = parse(pair[1])
              acc
          end
        end
      
      # If given a string
      when is_scalar?(yaml):
        if yaml.component_name?
          begin
            load_component(yaml)
          rescue Bob::UnknownComponent
            return yaml
          end
        else
          return yaml
        end
    end
  end
  
  protected
  
  #
  # Loads a component given its kind and YAML node value.
  #
  def self.load_component(kind, value = nil)
    # If the kind is not a valid component name or we can't find the definition
    definition = ComponentDefinition.load(kind, @@path)
    if definition.nil?
      raise UnknownComponent, "No definition available for component '#{kind}'"
    end
    
    # Otherwise, interpret its value and instantiate the component
    children = []
    parameters = {}
    case
      when value.is_a?(Hash):
        parameters = value

      when value.is_a?(Array):
        children = value
      
      when is_scalar?(value):
        children = [parse(value)]
    end
    
    definition.instantiate(parameters, value)
  end
  
  #
  # Returns true if the value is a scalar.
  #
  def self.is_scalar?(value)
    not [ Hash, Array, Component ].include?(value.class)
  end
end

class Object
  def render(format = :xhtml)
    to_s
  end
  
  #
  # Returns if the given string is a valid component name.
  #
  def component_name?
    # Valid if matches the component name regex
    self.to_s =~ Component::NameRegexp
  end
end

class Array
  def render(format = :xhtml)
    inject("") {|output, elem| output += elem.render}
  end
end


# Entry point

for arg in ARGV do
  Bob::path = "#{Bob::path}:/home/willmadden/Projects/Personal/Bob/lib"
  
  components = Bob::parse( YAML::load_file(arg) )
  
  puts components.render(:xhtml)
end

