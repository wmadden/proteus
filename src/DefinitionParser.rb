################################################################################
# DefinitionParser.rb
#
# Defines the DefinitionParser, used to load and parse component definitions.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'Component.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentDefinition.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'ParserHelper.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'FileFinder.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'DocumentParser.rb') )

include Bob

module Bob

  #
  # Parses component definitions.
  #
  # Important functions are load/2, which will return you a component definition
  # given the name (or nil), and - actually that's about all.
  #
  class DefinitionParser

    #
    # Loads and returns the named component definition.
    #
    # Searches for a file matching the component name, then a class and if
    # nothing matches returns nil.
    #
    def self.load(kind)
      # If it's a restricted definition, raise an exception
      if @@restricted_definitions.include?(kind)
        raise RecursiveDefinition, "Recursive definition detected: attempted to load restricted definition '#{kind}'."
      end
      
      # If it's already loaded, return the instance
      if @@definitions[kind]
        return @@definitions[kind]
      end
      
      # Otherwise look for a file, and if it exists, load the definition
      file = FileFinder.find_file("#{kind}.def")
      
      if file
        yaml = YAML::load_file(file)
        definition = parse(kind, yaml)
      elsif concrete_class = ParserHelper.get_class(kind)
        definition = ComponentDefinition.new(kind, {}, [kind], concrete_class)
      else
        raise UnknownDefinition, "Could not find definition for #{kind}, nor is it a loaded class"
      end
      
      @@definitions[kind] = definition
      return definition
    end

    #
    # Parses a type name and returns the parent, if any. If the name can't be
    # parsed, raises an exception.
    #
    # Returns nil if there is no parent.
    #
    # Note that all match data will be globally available in the $0, $1, $2...
    # variables.
    #
    def self.parse_name(name)
      if not matchdata = ParserHelper::DefinitionRegex.match(name)
        raise DefinitionMalformed, "Can't understand component name '#{name}'"
      end
      
      return matchdata[3]
    end

    #
    # Returns the list of ancestors for the named component definition.
    #
    # Second argument is the accumulator, and should start off as a list
    # containing only the original type.
    # 
    def self.get_ancestors(parent, ancestors)
      # If the parent is nil we're out of ancestors
      if parent.nil?
        return ancestors
      end
      
      # Load parent definition
      parent_def = self.load(parent)
      
      return get_ancestors( parent_def.parent, ancestors.push(parent) )
    end

    #
    # Parses YAML, returning a ComponentDefinition instance.
    #
    # Logic:
    #   We only accept a hash of type name to definition, or a scalar of just
    #   type name. A list is meaningless, and a hash of more than one pair is
    #   plain confusing.
    #
    #   If given a hash, parse the value as the definition's defaults.
    #
    #   Once the definition has been parsed, get its parent and merge the
    #   loaded defaults with the parent's.
    #
    #   Use the results to instantiate a new component definition, add it to
    #   the hash, and return it.
    #
    def self.parse(kind, yaml)
      # Push this kind on to the blacklist
      @@restricted_definitions.push(kind)
      
      begin
        # Parse based on yaml form
        if yaml.is_a?(Hash) and yaml.length == 1
          # Parse the defaults
          type = yaml.keys[0]
          
          defaults = parse_defaults(yaml.values[0])
        elsif ParserHelper.is_scalar?(yaml)
          type = yaml
          defaults = {}
        else
          raise DefinitionMalformed, "Definition of '#{kind}' malformed."
        end
        
        # Parse the type name
        parent = parse_name(type)
        
        # If there's no parent, assume Component
        if parent.nil?
          parent = Default
          ancestors = [kind, 'Component']
        
        # If parent is the same,
        elsif parent == kind
          # only permit the parent to be the same if it's a concrete component
          concrete_class = ParserHelper.get_class(kind)
          if concrete_class and ParserHelper.is_component?(concrete_class)
            ancestors = [kind]
            parent = ComponentDefinition.new( kind, {}, ancestors, concrete_class )
          else
            raise RecursiveDefinition, "Recursive definition detected: #{kind} is its own parent."
          end
        
        else
          # Check that the parent does not inherit from the current definition at
          # any point - i.e. definition is not recursive
          ancestors = get_ancestors(parent, [kind])
          # Get the parent definition
          parent = load(parent)
        end
        
        # Merge the defaults
        defaults = ComponentDefinition.merge_defaults(defaults, parent.defaults)
      rescue Exception
        @@restricted_definitions = []
        raise
      end
      
      # Reset the blacklist
      @@restricted_definitions = []
      
      return ComponentDefinition.new( kind, defaults, ancestors, parent.concrete_class )
    end

    #
    # Parses a hash of defaults.
    #
    def self.parse_defaults(yaml)
      if not yaml.is_a?(Hash)
        raise DefinitionMalformed, "Definition malformed - defaults not a hash."
      end
      
      template = yaml['template']
      children = nil
      parameters = nil
      # Decorators NYI
      
      # Parse parameters
      if yaml['parameters'].is_a?(Hash)
        parameters = DocumentParser.parse_hash(yaml['parameters'])
      elsif not yaml['parameters'].nil?
        raise DefinitionMalformed, "Definition malformed - parameters not a hash"
      end
      
      # Parse children
      if yaml['children'].is_a?(Array)
        children = DocumentParser.parse_list(yaml['children'])
      elsif not yaml['children'].nil?
        raise DefinitionMalformed, "Definition malformed - children not a list"
      end
      
      # If everything blank, warn the user
      raise EmptyDefinition if template.nil? and children.nil? and parameters.nil?
      
      return { :template => template, :parameters => parameters, :children => children }
    end
    
    # A list of definitions which cannot be loaded. This is used during parsing
    # to prevent recursive definitions.
    @@restricted_definitions = []
    
    # The hash of all loaded definitions
    @@definitions = {}
    
    # The default definition
    Default = load('Component')
  end
end
