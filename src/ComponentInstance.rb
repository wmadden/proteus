################################################################################
# ComponentInstance.rb
#
# Represents an instance of a component.
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
  
  class ComponentInstance
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( kind = ComponentClass::DEFAULT_CLASS,
      properties = {}, children = [] )
      
      @kind = kind
      @properties = properties
      @children = children
      
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
    attr_accessor :kind, :children, :properties
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
    #
    # Merges the component's properties with the class's and returns the result.
    #
    def final_properties
      return kind.properties.merge( @properties )
    end
    
    #
    # Merges the component's children with the class's and returns the result.
    #
    def final_children
      return kind.children.merge( @children )
    end
    
  end
  
end

