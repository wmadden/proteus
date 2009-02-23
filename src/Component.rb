################################################################################
# Component.rb
#
# Represents a component in an HTML layout.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require 'erb'

class Component

  attr_reader :kind, :params

  #
  # Constructor.
  #
  # Takes the set of parameters for the component, by default.
  #
  def initialize( kind, params )
    @kind = kind
    @params = params
    
    puts "Initializing #{kind}, #{params.inspect}"
    
    init(params)
  end
  
  
  def init(params)
  end
  
  
  #
  # Renders the component.
  #
  # Takes as parameter the format to render in.
  #
  def render( format )
    e = ERB.new(template)
    e.result( binding() )
  end


  #
  # Returns the default template (nothing).
  #
  def template
    ""
  end

  
  #
  # Loads a component from a YAML tree.
  #
  def self.load( kind, params = nil )
    #TODO: proper searching for files, etc
    
    # Get the class to instantiate
    begin
      cls = const_get(kind)
    rescue NameError
      cls = Component
    end
    
    cls.new(kind, params)
  end
  
  def inspect
    "<#{kind}, #{params.inspect}>"
  end
  
  def is_kind?(kind)
    @kind == kind
  end
end

