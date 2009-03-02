#!/usr/bin/ruby
################################################################################
# DocumentParser.rb
#
# Defines the DocumentParser, used to load and parse Bob documents. Will invoke
# the DefinitionParser, DecoratorParser and ComponentParser as needed.
# -----------------------------------------------------------------------------
# (C) Copyright 2009 William Madden
# 
# This file is part of Bob.
# 
# Bob is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Bob is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# Foobar.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require 'yaml'
require File.join(File.dirname(__FILE__), 'Exceptions.rb')
require File.join(File.dirname(__FILE__), 'ComponentParser.rb')
require File.join(File.dirname(__FILE__), 'DefinitionParser.rb')

module Bob
  
  #
  # Used to load and parse documents.
  #
  class DocumentParser
    @@path = DefinitionParser.path
    
    def self.path=(value)
      @@path = value
      DefinitionParser.path = @@path
    end
    
    def self.path
      @@path
    end
    
    #
    # Loads a file, given its name, and parses the contents.
    #
    def self.load_file(file)
      # Explicit self in case load is defined
      self.load(File.read(file))
    end
    
    #
    # Loads a string and parses the contents.
    #
    def self.load(data)
      parse( YAML::load(data) )
    end
    
    #
    # Parses a YAML tree and returns a list of components.
    #
    # Expects the yaml in a string.
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
              return ComponentParser.parse(yaml.keys.first, value)
            rescue UnknownComponent
              return {yaml.keys.first => value}
            end
          else
            return yaml.inject({}) do |acc, pair|
                acc[pair[0]] = parse(pair[1])
                acc
            end
          end
        
        # If given a scalar
        when ParserHelper.is_scalar?(yaml):
          if yaml.component_name?
            begin
              ComponentParser.parse(yaml)
            rescue UnknownComponent
              return yaml
            end
          else
            return yaml
          end
      end
    end
    
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
    Component::NameRegexp === self.to_s
  end
end

class Array
  def render(format = :xhtml)
    inject("") {|output, elem| output += elem.render}
  end
end
