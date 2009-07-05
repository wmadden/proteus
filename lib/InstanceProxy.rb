################################################################################
# InstanceProxy.rb
#
# Provides the environment for rendering templates.
# -----------------------------------------------------------------------------
# (C) Copyright 2009 William Madden
# 
# This file is part of Proteus.
# 
# Proteus is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Proteus is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# Proteus.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require File.expand_path( File.join(File.dirname(__FILE__), 'PropertyHash.rb') )


module Proteus
  
  #
  # Provides the environment for rendering templates.
  #
  class InstanceProxy
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( renderer, instance )
      @renderer = renderer
      @instance = instance
      
      @kind = @instance.kind
      @properties = @instance.final_properties
      @props = PropertyHash.new( @properties, self )
      @children = @instance.children
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_accessor :children, :properties
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Renders the target in the scope of the proxy.
    # 
    # If the target is a component instance and the properties and children
    # parameters are provided, they will be used in place of the target's
    # initial properties and children.
    #
    def render( target, properties = nil, children = nil )
      if target.is_a? ComponentInstance
        if not properties.nil?
          target.properties.merge!( properties )
        end
        if not children.nil?
          target.children = children
        end
      end
      
      @renderer.render( target, instance_env() )
    end
    
    #
    # Returns the binding in the scope of the proxy instance.
    #
    def instance_env( )
      return binding()
    end
    
    #
    # Redirects missing method calls to the properties or 'props' hashes.
    #
    # If the method name begins with '_', redirects it to the @props hash. If it
    # begins with '__', redirects it to the @properties hash.
    #
    def method_missing(m, *args)
      if /__.*/ === m
        return @properties[ m ]
      end
      
      if /_.*/ === m
        return @props[ m ]
      end
      
      super.method_missing( m, args )
    end
    
    #
    # Renders and returns the next child.
    #
    def next_child
      return @renderer.render( _next_child(), instance_env() )
    end
    
    #
    # Returns the next child, or nil.
    #
    def _next_child
      if @_last_child_index.nil?
        @last_child = nil
        @_last_child_index = 0
        return @children[ 0 ]
      end
      
      @last_child = @children[ @_last_child_index ]
      @_last_child_index += 1
      
      return @children[ @_last_child_index ]
    end
    
    #
    # Returns the remaining children (that have not been accessed using
    # next_child.
    #
    def remaining_children
      i = (@_last_child_index || 0) + 1
      return @children.slice( i..-1 ) || []
    end
    
  end

end

