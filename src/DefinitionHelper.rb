################################################################################
# DefinitionHelper.rb
#
# Responsible for loading definitions and maintaining the set of loaded classes.
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
require File.expand_path( File.join(File.dirname(__FILE__), 'FileHelper.rb') )

module Bob

  class DefinitionHelper
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( path = [], current_ns = [] )
      @loaded_classes = {}
      @current_ns = []
      @path = path
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
  
  public
    
    attr_accessor :path, :current_ns, :class_parser
  
  private
  
    attr_accessor :loaded_classes
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Returns the given class.
    # 
    # class_name: the name of the class to load
    # ns_path: its namespace path, an array of namespace identifiers
    # current_ns: the current namespace, an array of namespace identifiers
    #
    def get_class( class_name, ns_path = [], current_ns = [] )
      
      # Get the full class path
      if ns_path.length > 0
        class_path = ns_path + class_name
      else
        class_path = current_ns + class_name
      end
      
      # If it's already loaded, return it
      if @loaded_classes.has_key?( class_path )
        return @loaded_classes[ class_path ]
      end
      
      # Otherwise load it
      return load_class( class_path )
      
    end
    
    
  private
    
    #
    # Loads the given class.
    #
    # class_path: the full path of the class, including all namespaces
    #
    def load_class( class_path )
      # Create a new class,
      new_class = ComponentClass.new
      @loaded_classes[ class_path ] = new_class
      
      # load its definition,
      file = FileHelper.find_definition( class_path, @path )
      
      # parse it,
      if file.nil?
        raise DefinitionUnavailable, "File not found for class path: '" + class_path.inspect + "'"
      end
      
      yaml = YAML.load_file( file )
      
      @class_parser.parse_yaml( yaml, new_class )
      
      # and return the result.
      return new_class
    end
    
  end
  
end
