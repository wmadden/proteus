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
      @properties = @instance.properties
      @children = @instance.children
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_accessor :renderer, :instance, :kind, :properties, :children
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Returns the binding in the scope of the proxy instance.
    #
    def instance_env( )
      return binding()
    end
    
    #
    # Redirects missing method calls to the property hash.
    #
    def method_missing(m, *args)
      @properties[ m.to_s ]
    end
    
    #
    # Returns the next child, or nil.
    #
    def next_child
      if @_last_child_index.nil?
        @last_child = nil
        @_last_child_index = 0
        return children[0]
      end
      
      @last_child = children[ @_last_child_index ]
      @_last_child_index += 1
      
      return children[ @_last_child_index ]
    end
    
  end

end
