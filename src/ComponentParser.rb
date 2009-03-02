#!/usr/bin/ruby
################################################################################
# ComponentParser.rb
#
# Defines the ComponentParser, used to parse Component YAML.
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

require 'Component'
require 'DefinitionParser'
require 'ParserHelper'
require 'Exceptions'

module Bob

  #
  # Parses components.
  #
  class ComponentParser
    
    #
    # Parses YAML, returning a Component instance.
    #
    def self.parse(kind, yaml = nil)
      # If the kind is not a valid component name or we can't find the definition
      definition = DefinitionParser.load(kind)
      if definition.nil?
        raise UnknownComponent, "No definition available for component '#{kind}'"
        return
      end
      
      # Otherwise, interpret its value and instantiate the component
      children = []
      parameters = {}
      case
        when yaml.is_a?(Hash):
          children = yaml.delete('children')
          parameters = yaml

        when yaml.is_a?(Array):
          children = yaml
        
        when is_scalar?(yaml):
          children = [parse(yaml)]
      end
      
      definition.instantiate(parameters, children)
    end
    
  end
end
