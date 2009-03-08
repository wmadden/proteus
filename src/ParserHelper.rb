################################################################################
# ParserHelper.rb
#
# Provides useful functions for the parsers.
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

    ComponentRegex = /^[A-Z][a-zA-Z_0-9]*$/
    DefinitionRegex = /^([A-Z][a-zA-Z_0-9]*)([\s]*<[\s*]([A-Z][a-zA-Z_0-9]*))?$/

    def self.do_nothing
    end

    #
    # Returns the class given by name, or nil if it can't be found.
    #
    def self.get_class(name)
      klass = nil
      
      # See if it's a known class
      begin
        klass = const_get(name)
      rescue NameError
        do_nothing
      end
      
      # Otherwise try and require it.rb
      begin
        require "#{name}.rb"
        klass = const_get(name)
      rescue LoadError, NameError
        do_nothing
      end
      
      # If found something, check that it's actually a class
      if (not klass.nil?) and (not klass.is_a?(Class))
        return nil
      end
      
      # Otherwise return what we got
      return klass
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
