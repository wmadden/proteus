################################################################################
# DefinitionParser.rb
#
# Responsible for interpreting YAML for definition files.
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
# Bob.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require File.expand_path( File.join(File.dirname(__FILE__), 'ClassParser.rb') )

include Bob


module Bob
  
  class DefinitionParser
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( definition_helper = nil, class_parser = nil,
      input_parser = nil )
      
      @definition_helper = definition_helper
      @class_parser = class_parser
      @input_parser = input_parser
      
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_accessor :definition_helper, :class_parser, :input_parser
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Takes the YAML input read directly from the definition file and parses it,
    # returning the loaded ComponentClass.
    #
    # yaml: The input YAML to be parsed.
    # component_class: The component class to load.
    #
    def parse_yaml( yaml, component_class = nil )
      
      result = component_class || ComponentClass.new
      
      # Let the class parser handle interpreting the YAML, the load the parent
      # class and parse all the values in the children and properties of the new
      # component class.
      
      @class_parser.parse_yaml( yaml, result )
      
      # Get the parent class
      if result.parent != nil
        result.parent = @definition_helper.get_class( result.parent )
      end
      
      # Parse properties
      for property in result.properties
        result.properties[ property[0] ] =
          @input_parser.parse_yaml( property[1] )
      end
      
      # Parse children
      result.children.length.times do |i|
        result.children[i] = @input_parser.parse_yaml( result.children[i] )
      end
      
      return result
    end
    
  end
  
end
