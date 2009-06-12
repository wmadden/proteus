################################################################################
# ClassParser.rb
#
# Responsible for interpreting YAML for component classes.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'exceptions.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentClass.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionHelper.rb') )

module Bob
  
  #
  # Provides functions for parsing component definitions (for component
  # classes).
  # 
  class ClassParser
    
    # The regex for valid class names
    CLASS_RE = /^([A-Z][a-zA-Z_0-9]*)([\s]*<[\s*]([A-Z][a-zA-Z_0-9]*))?$/
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( definition_helper )
      @definition_helper = definition_helper
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  private
    
    attr_accessor :definition_helper
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Parses YAML and returns the resultant component class.
    # 
    # yaml: the YAML to parse
    # new_class: the class instance to parse
    #
    def parse_yaml( yaml, new_class = nil )
      result = new_class || ComponentClass.new
      
      # Must be a hash of length one containing a hash
      if not ( yaml.is_a?(Hash) and yaml.length == 1 and
        yaml.values[0].is_a?(Hash) ) then
        
        raise DefinitionMalformed
      end
      
      # Parse the class name
      name = yaml.keys[0]
      match = CLASS_RE.match( name )
      
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
