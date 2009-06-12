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

  class FileHelper
    
    # The default path to search for definitions
    DEFAULT_PATH = '/usr/lib/bob'
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
    #
    # Find a file on the path.
    # 
    # target: the file to search for
    # path: the path (standard UNIX path variable) to search
    #
    def self.find_file( target, path = nil )
      path = path || DEFAULT_PATH
      
      for filepath in path
        for file in Dir.new(filepath)
          return File.join(filepath, file) if file == target
        end
      end
      
      return nil
    end
    
    #
    # Find a definition file.
    # 
    # class_path: the full path of the class, including all namespaces
    #
    def self.find_definition( class_path, path = nil )
      path = path || DEFAULT_PATH
      
      if not current_ns.nil?
        file_path = current_ns + '/'
      end
      
      file_path += path_array.join('/')
      
      # Search the PATH for the file
      return self.find_file( file_path, path )
    end
    
  end
  
end

