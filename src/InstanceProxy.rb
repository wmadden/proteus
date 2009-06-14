################################################################################
# InstanceProxy.rb
#
# Provides the environment for rendering templates.
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

module Bob
  
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
      
      @properties = @instance.properties
      @children = @instance.children
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_accessor :renderer, :instance
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Returns the binding in the scope of the proxy instance.
    #
    def get_binding( )
      return binding()
    end
    
    #
    # Redirects missing method calls to the property hash.
    #
    def method_missing(m, *args)
      @properties[ m.to_s ]
    end
    
  end

end
