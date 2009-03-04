################################################################################
# FileFinder.rb
#
# Defines the FileFinder static class, which provides the find_file function,
# used to find files.
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
    # The path variable (follows standard UNIX convention). Paths in this array
    # will be searched (non-recursively) for definition files.
    @@path = ['.']
    
    def self.path=(value)
      @@path = value
    end

    def self.path
      @@path
    end

    #
    # Find a file.
    #
    def self.find_file(target, path = @@path)
      for filepath in path
        for file in Dir.new(filepath)
          return "#{filepath}/#{file}" if file == target
        end
      end
      
      return nil
    end
  end
end
