################################################################################
# InstanceParser.rb
#
# Responsible for interpreting YAML for component instances.
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
 
  class InstanceParser
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #
    # Interprets pre-parsed yaml and returns the loaded component instance.
    #
    def parse_yaml( class_instance, yaml )
      result = ComponentInstance.new( class_instance )
      
      case
        when yaml.is_a?( Array ):
          result.children = yaml
          
        when yaml.is_a?( Hash ):
          result.properties.merge!( yaml )
          
        when yaml.nil?:
          return result
          
        else
          result.children = [yaml]
      end
      
      return result
    end
    
  end
  
end
