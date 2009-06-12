################################################################################
# DefinitionParser.rb
#
# Parses component definition files.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentInstance.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentClass.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ParserHelper.rb') )

module Bob
  
  #
  # Provides functions for parsing component definitions (for component
  # classes).
  # 
  class DefinitionParser
    
    # The default path to search for definitions
    DEFAULT_PATH = '/usr/lib/bob'
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( path = nil, current_ns = nil )
      @path = path || DEFAULT_PATH
      @current_ns = current_ns || []
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
    # The path variable
    attr_accessor :path
    
    # The current namespace
    attr_accessor :current_ns
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
    # 
    # Searches for and loads the required component class.
    # 
    def load_component( component_id )
      file = FileHelper.find_definition( comp_path )
      
      if file.nil?
        raise DefinitionUnavailable
      end
      
      return parse_file( file )
    end
    
    #
    # Parses a definition file and returns the loaded component class.
    #
    def parse_file( file )
      yaml = YAML.parse_file(file)
      
      return parse_yaml( yaml )
    end
    
    #
    # Parses yaml and returns the loaded component class.
    #
    def parse_yaml( yaml )
      result = ComponentClass.new
      
      # Must be a hash of length one containing a hash
      if not ( yaml.is_a?(Hash) and yaml.length == 1 and
        yaml.values[0].is_a?(Hash) ) then
        
        raise DefinitionMalformed
        
      end
      
      # Parse the class name
      name = yaml.keys[0]
      match = ParserHelper::DEFINITION_RE.match( name )
      
      # If there's no match, the definition is malformed
      if match.nil?
        raise DefinitionMalformed
      end
      
      class_name = match[1]
      parent_name = match[2]
      
      properties = yaml.values[0]
      
      # Set the properties of the class to the given hash
      result.properties = properties
      
      return result
    end
    
  end
end
