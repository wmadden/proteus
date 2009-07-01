################################################################################
# App.rb
#
# Defines the standard executable application of Proteus used by bin/pro.
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

require 'getoptlong'
require 'rdoc/usage'

require File.expand_path( File.join(File.dirname(__FILE__), 'Facade.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'TemplateRenderer.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'exceptions.rb') )


module Proteus
  
  PROTEUS_VERSION = "v0.9.0"
  
  #
  # The Proteus application.
  #
  class App

    USAGE =
    """
  Usage:
    proteus [--path PATH] FILE1 [FILE2 ...]
    proteus --inline COMPONENT [--props PROPERTIES] [CHILD1 CHILD2 ...]
    proteus --help
  
  In the first form, parses each file in turn and outputs to stdout, if the
  filename _doesn't_ end in '.pro', otherwise outputs to the filename without
  the '.pro'.
  
  In the second form, instantiates a component instance of type COMPONENT, a
  fully qualified class name, and initializes its properties and children to the
  values given.
  
  Options:
    --help, -h            Display this message.
                         
    --inline, -i          Parse inline. Takes component information on the
                          command line and outputs the rendered component
                          instance.
                         
    --path, -p            Sets the path to search for component definitions.
                          Defaults to /usr/lib/proteus.
                          (If omitted, prints path and exits.)
                          
    --props, -P           Sets the properties for an inline component.
                          (e.g. `--props p1=v1,p2=v2,p3=v3`)
    
    --no-current, -C      Don't add current directory to path.
    
    --version, -V         Output version.
    
    --ignore-extension,   Ignore the extension, if any. By default this will be
    -E                    interpreted as the default namespace (appended to any
                          specified)."""
    
    PATH_ENV_VAR = 'PROTEUS_PATH'
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize
      # Option variables
      @inline = false
      @path = ENV[ PATH_ENV_VAR ] || FileHelper::DEFAULT_PATH
      @props = {}
      @current_ns = []
      @exclude_current = false
      @ignore_extension = false
      
      # Valid options
      @opts = GetoptLong.new(
        [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
        [ '--path', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
        [ '--inline', '-i', GetoptLong::NO_ARGUMENT ],
        [ '--props', '-P', GetoptLong::REQUIRED_ARGUMENT ],
        [ '--namespace', '-n', GetoptLong::REQUIRED_ARGUMENT ],
        [ '--no-current', '-C', GetoptLong::NO_ARGUMENT ],
        [ '--version', '-V', GetoptLong::NO_ARGUMENT ],
        [ '--ignore-extension', '-E', GetoptLong::NO_ARGUMENT ]
      )

      # Parse command line
      parse_command_line
      
      # Set up system
      @facade = Facade.new
      @facade.path = @path + ':.'
      
      # Initialize renderer
      @renderer = TemplateRenderer.new
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    # Command line options
    attr_accessor :inline, :path, :props, :current_ns, :exclude_current, :opts
    
    # Internals
    attr_accessor :facade, :renderer
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Runs the application.
    #
    def run( args = nil )
      args ||= ARGV
      
      if not @inline
        
        if args.length < 1
          exit_error( "Error: no target given." )
        elsif args.length > 1
          exit_error( "Error: multiple targets given." )
        end
        
        for file in args
          parse_file( file )
        end
        
      else
        
        if args.length < 1
          exit_error( "Error: no component identifier given." )
        end
        
        parse_inline( args.shift, @props, args )
        
      end
    end
    
  private
    
    #
    # Parses a file and returns the result.
    #
    def parse_file( file )
      
      # If the file ends in '.pro', infer the current namespace from the file and
      # output to the filename minus the '.pro'
      if /(.*)\.pro/ === file
        output_path = $1
        
        if not @ignore_extension
          # Take the second last extension
          new_ns = output_path.split('.')
          new_ns = new_ns.length > 1 ? [new_ns.last] : nil
        end
      end
      
      # Parse the document
      tree = @facade.parse_file( file, @current_ns.concat(new_ns || []) )
      
      # Render the document tree
      result = @renderer.render( tree )
      
      if output_path
        File.new( output_path, 'w' ) << result
      else
        puts result
      end
      
    end
    
    #
    # Parses a component inline and outputs the rendered result.
    #
    def parse_inline( component_id, component_properties, component_children )
      
      class_path = @facade.input_parser.parse_component_id( component_id )
      
      begin
        component_class = facade.definition_helper.get_class( class_path,
          @current_ns )
      rescue Exceptions::DefinitionUnavailable
        exit_error( "Error: no definition found for '" + component_id + "'." )
      end
      
      component_children = facade.input_parser.parse_yaml( component_children,
        @current_ns )
      
      instance = ComponentInstance.new( component_class, component_properties,
        component_children )
      
      facade.input_parser.parse_instance( instance, @current_ns )
      
      puts renderer.render( instance )
      
    end
    
    #
    # Prints the given error message and exits.
    #
    def exit_error( error )
      puts error
      puts USAGE
      exit( 1 )
    end
    
    #
    # Parses a property list given on the command line.
    #
    def parse_properties( props )
      result = {}
      
      props.split( ',' ).each do |prop|
        pair = prop.split(':')
        result[ pair[0] ] = pair[1]
      end
      
      return result
    end
    
    #
    # Parses command line arguments.
    #
    def parse_command_line

      @opts.each do |opt, arg|
        case opt
          when '--help', '-h'
            puts( USAGE )
            exit( 0 )
          when '--inline', '-i'
            @inline = true
          when '--props', '-P'
            @props = parse_props( arg )
          when '--path', '-p'
            if arg and arg != ''
              @path = arg
            else
              puts @path
              exit( 0 )
            end
          when '--namespace', '-n'
            @current_ns = arg.split(':')
          when '--no-current', '-C'
            @exclude_current = true
          when '--ignore-extension', '-E'
            @ignore_extension = true
          when '--version', '-V'
            puts( PROTEUS_VERSION )
            exit( 0 )
        end
      end

    end

  end
end
