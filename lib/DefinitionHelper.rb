################################################################################
# DefinitionHelper.rb
#
# Responsible for loading definitions and maintaining the set of loaded classes.
# -----------------------------------------------------------------------------
# (C) Copyright 2009 William Madden
# 
# This file is part of Proteus.
# 
# Proteus is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Proteus is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# Proteus.  If not, see <http://www.gnu.org/licenses/>.
################################################################################


require 'yaml'

require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'FileHelper.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'exceptions.rb') )


module Proteus

  class DefinitionHelper
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( definition_parser = nil, path = nil )
      @path = path
      @definition_parser = definition_parser
      
      @loaded_classes = {}
      @loading = []
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
  
  public
    
    attr_accessor :path, :definition_parser
  
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
    # class_path: an array containing the namespaces and class id of the class
    # current_ns: the current namespace, an array of namespace identifiers
    #
    def get_class( class_path, current_ns = nil )
      
      current_ns = current_ns || []
      
      # 1. Search the current namespace
      # 2. Search the default namespace
      begin
        result = find_class( current_ns.concat(class_path) )
      rescue Exceptions::DefinitionUnavailable
        result = find_class( class_path )
      end
      
    end
    
    
  private
  
    #
    # Searches for the given class and loads it if not found.
    #
    # class_path: the fully qualified class path, including ALL namespaces.
    #
    def find_class( class_path )
      
      # If it's already loaded, return it.
      if @loaded_classes.has_key?( class_path )
        return @loaded_classes[ class_path ]
      end
      
      # Otherwise create it,
      new_class = ComponentClass.new
      
      # add it to the dictionary,
      @loaded_classes[ class_path ] = new_class
      
      # load its definition,
      begin
        new_class = load_class( class_path, new_class )
      rescue Exception => exception
        # Load failed so delete it from the dictionary
        # TODO: consider dropping entire dictionary, since linked classes might
        # also be affected
        @loaded_classes.delete( class_path )
        
        raise exception
      end
      
      # and return it.
      return new_class
      
    end
    
    #
    # Loads the given class.
    #
    # class_path: the full path of the class, including all namespaces
    #
    def load_class( class_path, new_class )
      
      file = FileHelper.find_definition( class_path, @path )
      
      if file.nil?
        raise Exceptions::DefinitionUnavailable,
          "File not found for class path: '" + class_path.inspect + "'"
      end
      
      yaml = YAML.load_file( file )
      
      @definition_parser.parse_yaml( yaml, new_class, class_path.slice(0..-2) )
      
      if new_class.name != class_path[ class_path.length - 1 ]
        raise Exceptions::DefinitionMalformed,
          "Definition class name ('" + new_class.name +
          "') does not match file name ('" +
          class_path[ class_path.length - 1 ] + "')."
      end
      
      return new_class
    end
    
  end
end
