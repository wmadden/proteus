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

  attr_accessor :kind, :children, :template, :decorators, :definition
  attr_reader :params

  #
  # Constructor.
  #
  def initialize( definition,
                  params = {},
                  children = [],
                  template = "",
                  decorators = [] )

    @kind = definition.kind
    @children = children
    @template = template
    @decorators = decorators
    @params = params
    @definition = definition
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
    
    return output
  end
  
  #
  # Renders this component alone.
  #
  def render_self( format = :xhtml )
    begin
      e = ERB.new(@template)
      e.result( binding() )
    rescue Exception
      throw "Error rendering template: #{$!.message}\n#{$!.backtrace}"
    end
  end

  #
  # Renders all children of this component, in order, and returns the resultant
  # string.
  #  
  def render_children( format = :xhtml )
    output = ""
    
    @children.each do |child|
      output += child.render(format).to_s
    end
    
    return output
  end
  
  def missing_method(m, args)
    puts "Checking for #{m} in params... #{@params[m].nil? ? "N" : "Y"}"
    if not @params[m].nil?
      return @params[m]
    else
      super.missing_method(m, args)
    end
  end
end

