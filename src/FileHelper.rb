################################################################################
# FileHelper.rb
#
# Provides functions for locating and handling files.
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

  class FileFinder
    
    # The default path to search for definitions
    DEFAULT_PATH = '/usr/lib/bob'
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( )
      @path = ['.']
    end
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
    # The path variable (follows standard UNIX convention). Paths in this array
    # will be searched (non-recursively) for definition files.
    attr_accessor :path
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
    #
    # Find a file.
    #
    def find_file(target, path = @@path)
      for filepath in path
        for file in Dir.new(filepath)
          return File.join(filepath, file) if file == target
        end
      end
      
      return nil
    end
    
  end
end

