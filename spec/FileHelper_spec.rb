################################################################################
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

require File.expand_path( 'src/FileHelper.rb' )

include Bob


describe FileHelper do

  before(:all) do
    @path = "spec/test_lib_dir1:spec/test_lib_dir2"
  end
  
  # Search for "File1.def", it should be found in test_lib_dir1
  it "should return the first matching file"
  
  # Search for "File2.def", it should be found in test_lib_dir2
  it "should search all directories"
  
  # Search for ["File3"]
  it "should find definition files by classname"
  
  # Search for ["NS1", "File4"]
  it "should find definition files with one namespace"
  
  # Search for ["NS1", "NS2", "File5"]
  it "should find definition files with multiple namespaces"
  
  after(:all) do
  end
  
end
