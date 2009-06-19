################################################################################
# TemplateRenderer.rb
#
# Renders the document tree using component templates and ERB.
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

require 'erb'

require File.expand_path( File.join(File.dirname(__FILE__), 'ComponentInstance.rb') )
require File.expand_path( File.join(File.dirname(__FILE__), 'InstanceProxy.rb') )


module Proteus
  
  # 
  # Renders a document tree.
  # 
  class TemplateRenderer
    
    TEMPLATE_PROPERTY = "template"
    
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
      
      result = ''
      template = instance.final_properties[ TEMPLATE_PROPERTY ]
      
      if template != nil
        proxy = InstanceProxy.new( self, instance )
        
        e = ERB.new( template )
        result = e.result( proxy.instance_env() )
      end
      
      return result
      
    end
    
  end
  
end
