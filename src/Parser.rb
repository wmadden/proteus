################################################################################
# Parser.rb
#
# Parses input and returns the document tree.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'ParserHelper.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionParser.rb') )

module Bob
  
  # 
  # Provides functions for parsing definitions.
  # 
  class Parser
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( path = nil, current_ns = nil )
      @path = path
      @current_ns = current_ns || []
      @instance_parser = ComponentParser.new()
      @class_parser = DefinitionParser.new( @path, @current_ns )
      @loaded_classes = {}
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
    
    # The component instance parser
    attr_accessor :instance_parser
    
    # The class definition parser
    attr_accessor :class_parser
    
    # The map of loaded classes
    attr_accessor :loaded_classes
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
    #
    # Parses a definition file and returns the loaded component class.
    #
    def parse_file( file )
      yaml = YAML.load_file(file)
      
      return parse_yaml( yaml )
    end
    
    #
    # Parses yaml and returns the document tree.
    #
    def parse_yaml( yaml )
      
      case
        when yaml.is_a?( Array ):
          # Parse each node it contains and return the resultant array
          return parse_yaml_seq( yaml )
          
        when yaml.is_a?( Hash ):
          return parse_yaml_map( yaml )
        
        when yaml.nil?:
          return parse_yaml_nil()
          
        else
          return parse_yaml_scalar( yaml )
      end
      
    end
    
    #
    # Parses a YAML sequence (Array) returning the resultant array.
    #
    def parse_yaml_seq( yaml )
      yaml.map { |elem| parse_yaml(elem) }
    end
    
    #
    # Parses a YAML map (Hash) returning a component or a hash.
    #
    def parse_yaml_map( yaml )
      # If the hash has only one element and it's a valid component name,
      # parse it as a component
      if yaml.length == 1 and ParserHelper.component_name?( yaml.keys.first )
        # Parse the value mapped to the key
        value = parse_yaml( yaml.values.first )
        
        # Parse the component
        return parse_component( yaml.keys.first, value )
        
      # Otherwise, return the hash parsing each value
      else
        return yaml.inject({}) do |acc, pair|
            acc[pair[0]] = parse_yaml(pair[1])
            acc
        end
      end
    end
    
    #
    # Parses a YAML scalar.
    #
    def parse_yaml_scalar( yaml )
      if ParserHelper.component_name?( yaml ) then
        return parse_component( yaml )
      end
      
      return yaml
    end
    
    #
    # Parses a nil value.
    #
    def parse_yaml_nil()
      return nil
    end
    
    #
    # Parses a component.
    #
    def parse_component( type, value )
      
      # Parse the id for namespaces and type
      comp_path = ParserHelper.parse_component_id( type )
      comp_path = get_fqn( comp_path )
      
      # Get the class (loading it if required)
      cclass = get_class( comp_path )
      
      # 3. Invoke the instance parser
      @instance_parser.parse_yaml( cclass, value )
    end
    
    #
    # Returns the named component class.
    #
    def get_class( comp_path )
      # Get the class from the map of loaded classes
      cclass = get_loaded_class( comp_path )
      
      # If it hasn't been loaded, load it
      if cclass.nil?
        cclass = @class_parser.load_component( comp_path )
      end
      
      # Add it to the map
      @loaded_classes[comp_path] = cclass
      
      # Parse the properties hash values
      for pair in cclass.properties
        cclass.properties[ pair[0] ] = @parser.parse_yaml( pair[1] )
      end
      
      if cclass.parent.nil?
        # Set the parent class to the default
        # TODO
      else
        # Load the parent class
        parent_class = get_loaded_class( get_fqn(cclass.parent) )
        
        if parent_class.nil?
          parent_class = @class_parser.load( parent_class )
        end
        
        cclass.parent = parent_class
      end
    end
    
    #
    # Returns the named class from the map of classes, if loaded, or nil.
    #
    def get_loaded_class( comp_path )
      @loaded_classes[comp_path]
    end
    
    #
    # Returns the fully qualified name of the component.
    #
    def get_fqn( comp_path )
      # If the component path does not include a namespace, use the current
      # namespace.
      if comp_path.length <= 1 then
        return @current_namespace + comp_path
      end
      
      return comp_path
    end
    
  end
end
