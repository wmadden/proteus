################################################################################
# ComponentDefinition.rb
#
# Represents the definition of a component.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require 'Component.rb'
require 'yaml'

#
# Returns the class given by name, or nil if it can't be found.
#
def get_class(name)
  klass = nil
  
  begin
    require "#{name}.rb"
    klass = const_get(name)
  rescue LoadError, NameError
    return nil
  end
  
  # Check that it's actually a class
  if not klass.is_a?(Class)
    return nil
  end
  
  return klass
end

#
# Represents the definition of a component.
#
class ComponentDefinition

  attr_accessor :kind, :defaults, :parent, :concrete_class

  #
  # Constructor.
  #
  def initialize( kind, defaults, ancestors, concrete_class )
    @kind = kind
    @parent = ancestors[1]
    @concrete_class = concrete_class
    
    @parameters = defaults[:parameters] || {}
    @children = defaults[:children] || []
    @template = defaults[:template] || ""
    @decorators = defaults[:decorators] || []
  end

  # The default definition
  Default = ComponentDefinition.new("Component", {}, ["Component"], Component)
  # The hash of all loaded definitions
  @@definitions = {"Component" => Default}
  # The default path to search for definition files
  DEFAULT_PATH = "."
  
  #
  # Loads and returns the named component definition.
  #
  def self.load(kind, path = DEFAULT_PATH)
    # If it's already loaded, return the instance
    return @@definitions[kind] if @@definitions[kind]
    
    # Otherwise look for a file, and if it exists, load the definition
    file = find_file(kind)
    
    if file
      yaml = YAML::load_file(file, path)
      definition = parse(kind, yaml)
    end
    
    # Otherwise look for a concrete class with the same name
    if concrete_class = get_class(kind)
      definition = ComponentDefinition.new(kind, {}, [kind], concrete_class)
    end
    
    @@definitions[kind] = definition
    return definition
  end

  #
  # Find a definition file for the given type.
  #
  def self.find_file(kind, path = DEFAULT_PATH)
    target = "#{kind}.def"
    result = nil
    
    for filepath in path.split(":")
      for file in Dir.new(filepath)
        result = "#{filepath}/#{file}" if file == target
      end
    end
    
    return result
  end
  
  #
  # Parses a YAML document, returning a ComponentDefinition instance.
  #
  def self.parse(kind, yaml)
    case
      when yaml.is_a?(Hash):
        # Get the type name
        type = yaml.to_a[0][0]
        defaults = yaml.to_a[0][1] || {}
      
      when is_scalar?(yaml):
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
  # Merges this definition's defaults with a child definition's. Returns the
  # result (as a hash).
  #
  def merge_defaults( defaults )
    { :parameters => @parameters.merge( defaults["parameters"] || {} ),
      :children => defaults["children"] || @children,
      :template => defaults["template"] || "",
      :decorators => defaults["decorators"] || [] }
  end
  
  #
  # Parses a component name and returns the parent, if any. If the name can't be
  # parsed, throws an exception.
  #
  def self.parse_name(name)
    regex = Regexp.new("#{Component::NameRegexp.source}([\s]*<[\s]*(#{Component::NameRegexp.source}))?")
    if not matchdata = regex.match(name)
      throw "Can't understand component name '#{name}'"
    end
    
    return matchdata[2]
  end
  
  #
  # Returns the list of ancestors for the named component definition.
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
  
  #
  # Instantiates a component from this definition.
  #
  def instantiate( parameters = {}, children = nil, template = nil, decorators = nil )
    # Instantiate the class
    @concrete_class.new( @kind,
                         @parameters.merge(parameters),
                         children.nil? ? @children : children,
                         template.nil? ? @template : template,
                         decorators.nil? ? @decorators : decorators )
  end

end
