################################################################################
# ComponentDefinition.rb
#
# Represents the definition of a component.
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

require 'yaml'

module Bob
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
end
