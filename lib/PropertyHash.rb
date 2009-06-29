################################################################################
# PropertyHash.rb
#
# Wraps the properties of an instance used in the InstanceProxy, rendering its
# values before returning them.
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
  # Wraps the properties of an instance used in the InstanceProxy, rendering its
  # values before returning them.
  #
  class PropertyHash < Hash
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( properties, instance_proxy )
      super( properties )
      @instance_proxy = instance_proxy
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Overrides the default [] operator to render values before they're
    # returned.
    #
    def []( val )
      result = super[val]
      
      # Return nil immediately for convenience
      if result.nil?
        return nil
      end
      
      return @instance_proxy.render( result )
    end
    
  end
  
end

