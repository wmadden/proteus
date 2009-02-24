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

  attr_accessor :kind, :params, :children, :template, :decorators

  #
  # Constructor.
  #
  def initialize( kind = "Component", params = {}, children = [], template = "", decorators = [])
    @kind = kind
    @params = params
    @children = children
    @template = template
    @decorators = decorators
  end
  
  #
  # Renders the component.
  #
  # Takes as parameter the format to render in.
  #
  def render( format = :xhtml )
    # Render the component
    output = render_self(format)
    
    # Decorate the output
    for decorator in decorators
      decorator.decorate(output, format)
    end
  end
  
  #
  # Renders this component alone.
  #
  def render_self( format = :xhtml )
    e = ERB.new(@template)
    e.result( binding() )
  end

  #
  # Renders all children of this component, in order, and returns the resultant
  # string.
  #  
  def render_children( format = :xhtml )
    @children.each do |child|
      output += child.render(format)
    end
    
    return output
  end
end

