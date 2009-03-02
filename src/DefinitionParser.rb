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

    #
    # A list of definitions which cannot be loaded. This is used during parsing
    # to prevent recursive definitions.
    #
    @@restricted_definitions = []

    #
    # Loads and returns the named component definition.
    #
    def self.load(kind, path = @@path)
      $stderr.puts "Loading '#{kind.inspect}' definition"
      
      # If not given a kind to load, fail
      if kind.nil? or kind == ''
        throw "Can't load '#{kind}', not a valid definition name."
      end
      
      # If it's a restricted definition, throw an exception
      if @@restricted_definitions.include?(kind)
        throw "Recursive definition detected: attempted to load restricted definition '#{kind}'."
      end
      
      # If it's already loaded, return the instance
      if @@definitions[kind]
        $stderr.puts "Already loaded, returning #{@@definitions[kind].inspect}" 
        return @@definitions[kind]
      end
      
      # Otherwise look for a file, and if it exists, load the definition
      file = find_file(kind, path)
      
      if file
        yaml = YAML::load_file(file)
        $stderr.puts "Found file '#{file}', parsing definition"
        definition = parse(kind, yaml)
      # Otherwise look for a concrete class with the same name
      elsif concrete_class = ParserHelper.get_class(kind)
        definition = ComponentDefinition.new(kind, {}, [kind], concrete_class)
      # Otherwise return nil
      else
        return nil
      end
      
      @@definitions[kind] = definition
      return definition
    end
    
    #
    # The path variable (follows standard UNIX convention). Paths in this array
    # will be searched (non-recursively) for definition files.
    #
    @@path = ['.']
    # The default definition
    Default = ComponentDefinition.new("Component", {}, ["Component"], Component)
    # The hash of all loaded definitions
    @@definitions = {"Component" => Default}
    #
    # The regex used to parse definition names.
    #
    NameRegex = Regexp.new("#{Component::NameRegexp.source}([\s]*<[\s]*(#{Component::NameRegexp.source}))?")

    #
    # Accessor for @@path.
    # 
    def self.path=(value)
      @@path = value
    end

    #
    # Accessor for @@path.
    #     
    def self.path
      @@path
    end

    protected
    
    #
    # Find a definition file for the given type.
    #
    def self.find_file(kind, path = DEFAULT_PATH)
      target = "#{kind}.def"
      
      for filepath in path
        $stderr.print "Searching #{filepath}\n"
        for file in Dir.new(filepath)
          if file == target
            $stderr.puts "Found #{filepath}/#{file}"
            return "#{filepath}/#{file}" 
          end
        end
      end
      
      return nil
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
      $stderr.puts "Parsing #{kind}"
      type = nil
      defaults = nil
      
      if yaml.is_a?(Hash) and yaml.length == 1
        type = yaml.keys[0]
        
        # Blacklist the current type to prevent recursive definitions
        @@restricted_definitions.push(kind)
        
        # Parse defaults
        defaults = parse_defaults(yaml.values[0])
        
        # Clear the blacklist
        @@restricted_definitions = []
        
      elsif ParserHelper.is_scalar?(yaml)
        type = yaml
      else
        throw "Definition of '#{kind}' malformed."
      end
      
      # Parse the type name
      parent = parse_name(type)
      if parent.nil? or parent == ''
        parent = 'Component'
      end
      
      $stderr.puts "Parent is '#{parent}'"
      
      # Check that the parent does not inherit from the current definition at
      # any point - i.e. definition is not recursive
      ancestors = get_ancestors(parent, [kind])
      
      # Get the parent definition
      parent = load(parent)
      
      # Merge the defaults
      ComponentDefinition.merge_defaults(defaults, parent.defaults)
      
      # Instantiate the new definition
      definition = ComponentDefinition.new( kind, defaults, ancestors, parent.concrete_class )
      
      return definition
    end

    #
    # Parses a hash of defaults.
    #
    # Logic:
    #   Given a hash, we look for:
    #     1. Parameters (def composition)
    #     2. Children (def aggregation)
    #     3. Decorators
    #     4. Template
    #
    #   All parameter values must be parsed by the component parser, but may
    #   not include instances of the definition being parsed: we do not permit
    #   recursive definitions.
    #
    #   All children must similarly be parsed, but again we do not permit
    #   instances of the definition being parsed.
    #
    #   Decorators are not yet implemented, so ignore them.
    #
    #   The template is a flat string which will be parsed later.
    #
    def self.parse_defaults(yaml)
      if not yaml.is_a?(Hash)
        throw "Definition of '#{kind}' malformed - definition not a hash."
      end
      
      template = yaml['template']
      children = yaml['children']
      parameters = yaml['parameters']
      # Decorators NYI
      #decorators = yaml['decorators']
      
      # Parse parameters
      if not parameters.nil?
        if parameters.is_a?(Hash)
          # Parse each parameter value as a component
          param_result = parameters.inject({}) do |acc, pair|
              begin
                acc[pair[0]] = DocumentParser.parse(pair[1])
              rescue UnknownComponent
                acc[pair[0]] = pair[1]
              end
              acc
          end
          
          parameters = param_result
        else
          throw "Definition of '#{kind}' malformed - parameters not a hash."
        end
      end
      
      # Parse children
      if not children.nil?
        if children.is_a?(Array)
          # Parse each child as a component
          children_result = parameters.inject({}) do |acc, child|
              begin
                acc.add( DocumentParser.parse(pair[1]) )
              rescue UnknownComponent
                acc.add(child)
              end
              acc
          end
          
          children = children_result
        else
          throw "Definition of '#{kind}' malformed - children not a list."
        end
      end
      
      # If everything blank, warn the user
      if template.nil? and children.nil? and parameters.nil?
        raise EmptyDefinition
      end
      
      return { :template => template,
               :parameters => parameters,
               :children => children }
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
    # Recursive function. The second argument is the accumulator, which should
    # begin as a list containing the kind whose ancestors you want.
    #
    # E.g. get_ancestors('SomeParent', ['SomeKind']) will return the ancestors
    # of 'SomeKind'.
    #
    # Throws an exception in the even of a recursive definition.
    #
    def self.get_ancestors(parent, ancestors)
      # Check that parent is not in ancestors
      if ancestors.include?(parent)
        throw "Recursive component definition #{ancestors[0]}"
      end
      
      # Get parent definition
      definition = load(parent)
      
      if definition.nil?
        throw "Couldn't find definition for ancestor '#{parent}'"
      end
      
      return get_ancestors(definition.parent, ancestors.push(parent))
    end
    
  end

end
