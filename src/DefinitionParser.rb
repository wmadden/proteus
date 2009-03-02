#!/usr/bin/ruby
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
# Foobar.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require 'ComponentDefinition'
require 'ParserHelper'

module Bob

  #
  # Parses component definitions.
  #
  # Important functions are load/2, which will return you a component definition
  # given the name (or nil), and - actually that's about all.
  #
  class DefinitionParser

    # A list of definitions which cannot be loaded. This is used during parsing
    # to prevent recursive definitions.
    @@restricted_definitions = []
    # The path variable (follows standard UNIX convention). Paths in this array
    # will be searched (non-recursively) for definition files.
    @@path = ['.']
    # The default definition
    Default = ComponentDefinition.new("Component", {}, ["Component"], Component)
    # The hash of all loaded definitions
    @@definitions = {"Component" => Default}
    # The regex used to parse definition names.
    NameRegex = Regexp.new("#{Component::NameRegexp.source}([\s]*<[\s]*(#{Component::NameRegexp.source}))?")

    # Accessor for @@path.
    def self.path=(value)
      @@path = value
    end

    # Accessor for @@path.
    def self.path
      @@path
    end

    #
    # Loads and returns the named component definition.
    #
    # Searches for a file matching the component name, then a class and if
    # nothing matches returns nil.
    #
    def self.load(kind, path = @@path)
      # If it's a restricted definition, throw an exception
      if @@restricted_definitions.include?(kind)
        throw "Recursive definition detected: attempted to load restricted definition '#{kind}'."
      end
      
      # If it's already loaded, return the instance
      if @@definitions[kind]
        return @@definitions[kind]
      end
      
      # Otherwise look for a file, and if it exists, load the definition
      file = find_file(kind, path)
      
      if file
        yaml = YAML::load_file(file)
        definition = parse(kind, yaml)
      elsif concrete_class = ParserHelper.get_class(kind)
        definition = ComponentDefinition.new(kind, {}, [kind], concrete_class)
      else
        return nil
      end
      
      @@definitions[kind] = definition
      return definition
    end

    protected
    
    #
    # Find a definition file for the given type.
    #
    def self.find_file(kind, path = DEFAULT_PATH)
      target = "#{kind}.def"
      
      for filepath in path
        for file in Dir.new(filepath)
          return "#{filepath}/#{file}" if file == target
        end
      end
      
      return nil
    end

    #
    # Parses a type name and returns the parent, if any. If the name can't be
    # parsed, throws an exception.
    #
    # Returns nil if there is no parent.
    #
    # Note that all match data will be globally available in the $0, $1, $2...
    # variables.
    #
    def self.parse_name(name)
      if not matchdata = NameRegex.match(name)
        throw "Can't understand component name '#{name}'"
      end
      
      return matchdata[2]
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
      
      # Do not permit recursive types
      if ancestors.include?(parent)
        throw "Recursive definition detected: 'parent' inherits from itself."
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
      # Parse based on yaml form
      if yaml.is_a?(Hash) and yaml.length == 1
        # Parse the defaults, restricting the current type to avoid recursive
        # definition
        type = yaml.keys[0]
        @@restricted_definitions.push(kind)
        
        defaults = parse_defaults(yaml.values[0])
      elsif ParserHelper.is_scalar?(yaml)
        type = yaml
        defaults = {}
      else
        throw "Definition of '#{kind}' malformed."
      end
      
      # Parse the type name
      parent = parse_name(type)
      # If there's no parent, assume Component
      if parent.nil?
        parent = Default
        ancestors = [kind, 'Component']
      else
        # Check that the parent does not inherit from the current definition at
        # any point - i.e. definition is not recursive
        ancestors = get_ancestors(parent, [kind])
        # Get the parent definition
        parent = load(parent)
      end
      
      # Merge the defaults
      defaults = ComponentDefinition.merge_defaults(defaults, parent.defaults)
      
      # Reset the blacklist
      @@restricted_definitions = []
      
      return ComponentDefinition.new( kind, defaults, ancestors, parent.concrete_class )
    end

    #
    # Parses a hash of defaults.
    #
    def self.parse_defaults(yaml)
      if not yaml.is_a?(Hash)
        throw "Definition malformed - defaults not a hash."
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
    
  end
end
