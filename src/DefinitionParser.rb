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
    
    def initialize( )
      :path = DEFAULT_PATH
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
      
      # TODO
      #   1. Search for the definition file
      #   2. If not found, fail
      #   3. If found, parse it and return the result
      
      
      
      file = FileHelper.find_definition( comp_path )
      
      if file.nil?
        raise DefinitionUnavailable
      end
      
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
      
      # TODO
      
      return result
    end
    
  end
end
