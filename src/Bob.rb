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
  
  #
  # Loads a file, given its name, and parses the contents.
  #
  def Bob.load(file)
    parse(YAML.load_file(file))
  end
  
  #
  # Parses a YAML tree and returns a list of components.
  #
  def Bob.parse(yaml)
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
          rescue Exception
            return {yaml.keys.first => value}
          end
        else
          return yaml.inject({}) do |acc, pair|
              acc[pair[0]] = parse(pair[1])
              # Explicit return; acc[pair[0]] = parse(pair[1]) returns parse(pair[1])
              acc
          end
        end
      
      # If given a string
      when is_scalar?(yaml):
        if yaml.component_name?
          begin
            load_component(yaml)
          rescue Exception
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
  def Bob.load_component(kind, value = nil)
    # If the kind is not a valid component name or we can't find the definition
    definition = ComponentDefinition.load(kind)
    if definition.nil?
      throw "No definition available for component '#{kind}'"
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
end

#
# Returns true if the value is a scalar.
#
def is_scalar?(value)
  not [ Hash, Array, Component ].include?(value.class)
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
  #puts "Parsing #{arg}: #{arg}"
  
  components = Bob::parse( YAML::load_file(arg) )
  
  puts components.render(:xhtml)
end

