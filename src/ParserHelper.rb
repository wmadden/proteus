################################################################################
# ParserHelper.rb
#
# A shared resource between parsers.
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

  class ParserHelper
    
    # The regex defining valid component class names
    CLASS_RE = /^[A-Z][a-zA-Z_0-9]*$/
    # The regex defining valid namespace names
    NAMESPACE_RE = /^[a-zA-Z_0-9]+$/
    
    #
    # Returns true if the given string is a valid component name.
    #
    def self.component_name?( value )
      # Valid if the given value matches the component regex
      COMPONENT_RE === value.to_s
    end
    
    #
    # Parses a component identifier. Returns a list containing namespaces and
    # the component name or nil.
    #
    def self.parse_component_id( component_id )
      result = COMPONENT_RE.match( component_id )
      result = result.to_a
      
      # Remove the first element
      result.shift
      
      return result
    end
    
    #
    # Returns the class given by name, or nil if it can't be found.
    #
    def self.get_class(kind)
      begin
        # If it's a known class
        return const_get(kind)
      rescue NameError
      end
      
      begin
        # Otherwise, try loading the file
        require name
        # then try looking for the class
        return const_get(kind)
      rescue LoadError, NameError
        return nil
      end
    end
    
    #
    # Returns true if the value is a scalar.
    #
    def self.is_scalar?(value)
      not [ Hash, Array, Component, NilClass ].include?(value.class)
    end
    
    #
    # Returns true if the class inherits from Component.
    #
    def self.is_component?(klass)
      return klass.ancestors.include?(Component)
    end
  end

end
