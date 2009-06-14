################################################################################
# TemplateRenderer.rb
#
# Renders the document tree using component templates and ERB.
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

require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentInstance.rb') )


module Bob
  
  #
  # Add the get_binding function to the ComponentInstance class to support ERB
  # templating.
  #
  class ComponentInstance
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Returns the binding in the scope of the instance.
    #
    def get_binding( )
      return binding
    end
    
  end
  
  # 
  # Renders a document tree.
  # 
  class TemplateRenderer
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Renders a document tree.
    #
    def render( tree )
      
      case
        when tree.is_a?( ComponentInstance ):
          return render_instance( tree )
        
        when tree.is_a?( Array ):
          return render_array( tree )
          
        when tree.is_a?( Hash ):
          return render_hash( tree )
        
        when tree.nil?:
          return ''
          
        else
          return render_scalar( tree )
      end
      
    end
    
  private
    
    #
    # Renders a hash.
    #
    def render_hash( hash )
      
      for pair in hash
        hash[ pair[0] ] = render( pair[1] )
      end
      
      return hash.to_s
      
    end
    
    #
    # Renders an array.
    #
    def render_array( array )
      
      result = ''
      
      array.each do |elem|
        result += render( elem )
      end
      
      return result
      
    end
    
    #
    # Renders a scalar.
    #
    def render_scalar( scalar )
      return scalar.to_s
    end
    
    #
    # Renders an instance.
    #
    def render_instance( instance )
    
      template = instance.properties[ TEMPLATE_PROPERTY ]
      
      if template != nil
        e = ERB.new(  )
        e.result( instance.get_binding() )
      end
      
      return result
      
    end
    
  end
  
end
