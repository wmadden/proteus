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
      # If given a string
      when is_scalar?(yaml):
        if component_name?(yaml)
          load_component(yaml)
        else
          yaml
        end
      
      # If given a list
      when yaml.is_a?(Array):
        # Map list to a list of components
        yaml.map { |elem| parse(elem) }
        
      # If given a hash
      when yaml.is_a?(Hash):
        # TODO: come up with better syntax for this
         # TODO: come up with better syntax for this
        if yaml.length == 1
          yaml.each do |key, value|
            if component_name?(key)
               return load_component(key, parse(value))
            end
          end
        end
        
        return yaml.inject({}) { |acc, elem| acc[elem[0]] = parse(elem[1]) }
    end
  end
  
  #
  # Returns if the given string is a valid component name.
  #
  def Bob.component_name?(string)
    # Valid if matches the component name regex
    string =~ Component::NameRegexp
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

#
# Returns true if the value is a scalar.
#
def is_scalar?(value)
  not (value.is_a?(Array) || value.is_a?(Hash))
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
  
  components = Bob::parse( YAML::load_file(arg) )
  
  puts components.render(:xhtml)
end

