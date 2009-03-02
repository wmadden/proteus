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
    # Loads and returns the named component definition.
    #
    def self.load(kind, path = @@path)
      # If it's already loaded, return the instance
      return @@definitions[kind] if @@definitions[kind]
      
      # Otherwise look for a file, and if it exists, load the definition
      file = find_file(kind, path)
      
      if file
        yaml = YAML::load_file(file)
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
    def self.parse(kind, yaml)
      case
        when yaml.is_a?(Hash):
          # Get the type name
          type = yaml.to_a[0][0]
          defaults = yaml.to_a[0][1] || {}
        
        when ParserHelper.is_scalar?(yaml):
          type = yaml
          defaults = {}
        
        # Otherwise
        when true:
          throw "Malformed component definition"
      end
      
      # Get the parent, if specified
      parent = parse_name(type)
      
      # Get ancestors
      if parent
        ancestors = get_ancestors(parent, [kind])
      else
        ancestors = [kind, "Component"]
      end
      
      # Get the parent definition
      parent = load(parent) || Default
      
      # Merge defaults with the parent
      defaults = parent.merge_defaults(defaults)
      
      ComponentDefinition.new(kind, defaults, ancestors, parent.concrete_class)
    end

    #
    # Parses a component name and returns the parent, if any. If the name can't be
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
    def get_ancestors(parent, ancestors)
      # Check that parent is not in ancestors
      if ancestors.include?(parent)
        throw "Recursive component definition #{ancestors[0]}"
      end
      
      # Get parent definition
      definition = load(parent)
      
      return get_ancestors(definition.parent, ancestors.push(parent))
    end
    
  end

end
