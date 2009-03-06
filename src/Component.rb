################################################################################
# Component.rb
#
# Represents a component in an HTML layout.
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

require 'erb'

module Bob
  class Component

    attr_accessor :kind, :children, :template, :decorators, :params
    
    #
    # Constructor.
    #
    def initialize( kind = "Component",
                    params = {},
                    children = [],
                    template = "",
                    decorators = [] )

      # Ensure that these default to acceptable types
      @kind = kind || "Component"
      @children = children || []
      @last_child_index = 0
      @template = template || ""
      @decorators = decorators || []
      @params = params || {}
    end
    
    #
    # The regex used to identify component names.
    #
    NameRegexp = /^[A-Z][a-zA-Z_0-9]*$/
    
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
    
    def next_child
      @last_child_index += 1
      return @children[@last_child_index - 1]
    end
    
    def to_s
      render
    end
    
    #
    # If we try to access a non-existant method within the scope of the Component,
    # (e.g. while rendering the template), try and provide the matching parameter
    # value
    #
    def method_missing(m, *args)
      @params[m.to_s]
    end
    
  end
end
