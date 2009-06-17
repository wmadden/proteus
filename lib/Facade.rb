################################################################################
# Facade.rb
#
# An implementation of the Facade pattern. Provides an easy way to handle the
# parser and helper classes.
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


require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionHelper.rb') )

require File.expand_path( File.join(File.dirname(__FILE__), 'InstanceParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ClassParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'InputParser.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'DefinitionParser.rb') )

module Proteus
  
  class Facade
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( )
      
      # Instance parser
      @instance_parser = InstanceParser.new
      
      # Class parser
      @class_parser = ClassParser.new
      
      # Definition parser
      @definition_parser = DefinitionParser.new
      @definition_parser.class_parser = @class_parser
      
      # Definition helper
      @definition_helper = DefinitionHelper.new
      @definition_helper.definition_parser = @definition_parser
      
      @definition_parser.definition_helper = @definition_helper
      
      # Input parser
      @input_parser = InputParser.new
      @input_parser.instance_parser = @instance_parser
      @input_parser.definition_helper = @definition_helper
      
      @definition_parser.input_parser = @input_parser
      
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    # Parsers
    attr_accessor :class_parser, :instance_parser, :definition_parser,
      :input_parser
    
    # Helpers
    attr_accessor :definition_helper
    
    # Properties
    attr_reader :path, :current_ns
    
    def path=( value )
      @path = value
      @definition_helper.path = value
    end

    def current_ns=( value )
      @current_ns = value
      @definition_helper.current_ns = value
      @input_parser.current_ns = value
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Parses the given input YAML.
    #
    def parse_input( yaml )
      return @input_parser.parse_yaml( yaml )
    end
    
    #
    # Parses the given input file.
    #
    def parse_file( file )
      return @input_parser.parse_yaml( YAML.load_file(file) )
    end
    
  end
  
end

