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
# Represents the definition of a component.
#
class ComponentDefinition

  attr_accessor :kind, :defaults
  attr_accessor :parent, :concrete_class, :concrete, :ancestors

  #
  # Constructor.
  #
  def initialize( kind, defaults, ancestors, concrete_class )
    @kind = kind
    @parent = ancestors[1]
    @concrete_class = concrete_class
    
    @parameters = defaults["parameters"]
    @parameters = {} if @parameters.nil?
    
    @children = defaults["children"]
    @children = [] if @children.nil?
    
    @template = defaults["template"]
    @template = "" if @template.nil?
    
    @decorators = defaults["decorators"]
    @decorators = [] if @decorators.nil?
  end

  # The default definition
  @@Default = ComponentDefinition.new("Component", {}, ["Component"], Component)
  # The hash of all loaded definitions
  @@definitions = {"Component" => @@Default}

  #
  # Loads and returns the named component definition.
  #
  def self.load(kind)
    # If it's already loaded, return the instance
    return @@definitions[kind] if @@definitions[kind]
    
    # TODO: proper file searching
    # Look for a file with the same name
    file = "#{kind}.def"
    
    if File.exist?(file)
      yaml = YAML::load_file(file)
      definition = parse(kind, yaml)
    else
      concrete_class = get_class(kind)
      
      definition = ComponentDefinition.new(kind, {}, [kind], concrete_class)
    end

    # TODO: combine defaults with parent's defaults    
    
    # Store it in the hash  
    @@definitions[kind] = definition
  end
  
  #
  # Returns the class given by name, or @@Default if it can't be found.
  #
  #
  # Description.
  #
  def self.get_class(name)
    concrete_class = nil
    
    begin
      require "#{name}.rb"
      concrete_class = const_get(name)
    rescue LoadError, NameError
      return Component
    end
    
    return concrete_class
  end
  
  #
  # Parses a YAML document, returning a ComponentDefinition instance.
  #
  def self.parse(kind, yaml)
    case
      when yaml.is_a?(Hash):
        # Get the type name
        type = yaml.to_a[0][0]
        defaults = yaml.to_a[0][1]
      
      when true:
        throw "Component definition malformed - fix it!"
    end
    
    # Get ancestors
    parent = type[/<(.*)/, 1]
    
    if parent.nil?
      ancestors = [kind, "Component"]
    else
      ancestors = get_ancestors(parent, [kind])
    end
    
    # Attempt to use a known type, if there is one
    concrete_class = get_class(parent)
    
    if concrete_class.nil?
      # If not, ensure that it's not its own parent
      if parent == kind
        throw "Recursive component definition."
      else
        concrete_class = load(parent).concrete_class
      end
    end
    
    component = ComponentDefinition.new(kind, defaults, ancestors, concrete_class)
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
    
    # Recurse
    return get_ancestors(definition.parent, ancestors.push(parent))
  end
  
  #
  # Instantiates a component from this definition.
  #
  def instantiate( parameters = {}, children = nil, template = nil, decorators = nil )
    # Instantiate the class
    @concrete_class.new( self,
                         @parameters.merge(parameters),
                         children.nil? ? @children : children,
                         template.nil? ? @template : template,
                         decorators.nil? ? @decorators : decorators )
  end

end
