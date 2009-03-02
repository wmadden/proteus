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
      
      @defaults = defaults
      @parameters = defaults[:parameters] || {}
      @children = defaults[:children] || []
      @template = defaults[:template] || ""
      @decorators = defaults[:decorators] || []
    end
    
    #
    # Merges two sets of defaults, parent and child's.
    # Note: doesn't handle decorators yet
    #
    def self.merge_defaults( child_defs, parent_defs )
      # If the parent has parameters, merge them with the child's
      if parent_defs[:parameters].nil?
        parameters = child_defs[:parameters]
      else
        parameters = parent_defs[:parameters].merge( child_defs[:parameters] || {} )
      end
      
      # If the child has a template, that overrides the parent's
      template = child_defs[:template] || parent_defs[:template]
    
      # If the child has children, they override the parent's
      children = child_defs[:children] || parent_defs[:children]
      
      return { :parameters => parameters,
               :children => children,
               :template => template }
    end
    
    #
    # Instantiates a component from this definition.
    #
    def instantiate( parameters = {}, children = nil, template = nil, decorators = nil )
      # Instantiate the class
      @concrete_class.new( @kind,
                           @parameters.merge(parameters),
                           children || @children,
                           template || @template,
                           decorators || @decorators )
    end

  end
end
