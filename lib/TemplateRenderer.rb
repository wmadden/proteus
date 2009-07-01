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
    # Renders a document tree (optionally in the given scope).
    #
    def render( tree, binding = nil )
      
      case
        when tree.is_a?( ComponentInstance ):
          return render_instance( tree )
        
        when tree.is_a?( Array ):
          return render_array( tree, binding )
          
        when tree.is_a?( Hash ):
          return render_hash( tree, binding )
        
        when tree.nil?:
          return ''
          
        else
          return render_scalar( tree, binding )
      end
      
    end
    
  private
    
    #
    # Renders a hash.
    #
    def render_hash( hash, binding )
      
      for pair in hash
        hash[ pair[0] ] = render( pair[1], binding )
      end
      
      return hash.to_s
      
    end
    
    #
    # Renders an array.
    #
    def render_array( array, binding )
      
      result = ''
      
      array.each do |elem|
        result += render( elem, binding )
      end
      
      return result
      
    end
    
    #
    # Renders a scalar.
    #
    def render_scalar( scalar, binding )
      e = ERB.new( scalar.to_s )
      
      if binding.nil?
        begin
          return e.result()
        rescue => e
          if e.is_a? Exceptions::RenderError
            raise e
          end
          
          raise Exceptions::RenderError,
            "Error while rendering " + instance.inspect + ": " + e.message
        end
      end
      
      return e.result( binding )
    end
    
    #
    # Renders an instance.
    #
    # Unlike its siblings, this method does not accept a binding, instead using
    # the scope of the given instance.
    #
    def render_instance( instance )
      
      result = ''
      template = instance.final_properties[ TEMPLATE_PROPERTY ]
      
      if template != nil
        proxy = InstanceProxy.new( self, instance )
        
        e = ERB.new( template, nil, '>' )
        
        begin
          result = e.result( proxy.instance_env() )
        rescue => e
          if e.is_a? Exceptions::RenderError
            raise e
          end
          
          raise Exceptions::RenderError,
            "Error while rendering " + instance.kind.name + ":\n" + e.message +
              "\n\t" + e.backtrace.join("\n\t") +
              "\nComponent:\n\t" + instance.inspect
        end
      end
      
      return result
      
    end
    
  end
  
end
