################################################################################
# DocumentParser.rb
#
# Parses document YAML and returns the instance tree.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionHelper.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentInstance.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ClassParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'InstanceParser.rb') )

module Bob
  
  # 
  # Provides functions for parsing definitions.
  # require "DocumentParser.rb" and include Bob and p = DocumentParser.new and result = p.parse_yaml( YAML.load_file("../test/test.yml") )
  class DocumentParser
    
    # A regex defining valid component identifiers
    COMPONENT_RE = /^([a-zA-Z_0-9]+:)*([A-Z][a-zA-Z_0-9]*)$/
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( path = nil, current_ns = nil )
      @path = path
      @current_ns = current_ns || []
      @instance_parser = InstanceParser.new()
      
      @definition_helper = DefinitionHelper.new( path, current_ns )
      @class_parser = ClassParser.new( @definition_helper )
      
      @definition_helper.class_parser = @class_parser
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_accessor :path, :current_ns, :instance_parser
    
  private
    
    attr_accessor :definition_helper
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  parse_yaml
    #------------------------------
    
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
    
    
    #------------------------------
    #  parse_yaml_seq
    #------------------------------
    
    # 
    # Parses a YAML sequence (Array) returning the resultant array.
    # 
    def parse_yaml_seq( yaml )
      
      return yaml.map { |elem| parse_yaml(elem) }
      
    end
    
    #------------------------------
    #  parse_yaml_map
    #------------------------------
    
    # 
    # Parses a YAML map (Hash) returning a component or a hash.
    # 
    def parse_yaml_map( yaml )
      
      # If the hash has only one element and it's a valid component name,
      # parse it as a component.
      
      if yaml.length == 1 and COMPONENT_RE === yaml.keys.first
        
        # Parse the value mapped to the key
        value = parse_yaml( yaml.values.first )
        
        # Parse the component
        return parse_component( yaml.keys.first, value )
        
      else
      
        # Otherwise return the hash, parsing each value.
        return yaml.inject({}) do |acc, pair|
            acc[pair[0]] = parse_yaml(pair[1])
            acc
        end
        
      end
      
    end
    
    #------------------------------
    #  parse_yaml_scalar
    #------------------------------
    
    # 
    # Parses a YAML scalar.
    # 
    def parse_yaml_scalar( yaml )
      
      if COMPONENT_RE === yaml then
        return parse_component( yaml )
      end
      
      return yaml
      
    end
    
    #------------------------------
    #  parse_yaml_nil
    #------------------------------
    
    # 
    # Parses a nil value.
    # 
    def parse_yaml_nil()
      
      return nil
      
    end
    
    #------------------------------
    #  parse_component
    #------------------------------
    
    # 
    # Parses a component.
    # 
    # component_id: a component identifier (e.g. HTML:div)
    # yaml: the YAML describing the instance
    # 
    def parse_component( component_id, yaml )
    
      # Parse the id for namespaces and type
      class_path = parse_component_id( component_id )
      
      # Get the class (loading it if required)
      class_instance = @definition_helper.get_class( class_path )
      
      # Parse the YAML into the instance
      return @instance_parser.parse_yaml( class_instance, yaml )
      
    end
    
    #------------------------------
    #  parse_component_id
    #------------------------------
    
    # 
    # Parses a component identifier for the class path.
    # 
    def parse_component_id( component_id )
      return component_id.split(':')
    end
    
  end
  
end
