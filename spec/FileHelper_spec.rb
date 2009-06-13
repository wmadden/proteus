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
  
  LIB_DIR_1 = "spec/test_lib_dir1"
  LIB_DIR_2 = "spec/test_lib_dir2"
  PATH = LIB_DIR_1 + ":" + LIB_DIR_2
  
  # Correct answers
  FILE_1_PATH = LIB_DIR_1 + "/File1.def"
  FILE_2_PATH = LIB_DIR_2 + "/File2.def"
  FILE_3_PATH = LIB_DIR_1 + "/File3.def"
  FILE_4_PATH = LIB_DIR_1 + "/NS1/File4.def"
  FILE_5_PATH = LIB_DIR_1 + "/NS1/NS2/File5.def"
  
  #
  # Handle collisions - return first match.
  #
  it "should return the first matching file" do
  
    # Search for "File1.def", it should be found in test_lib_dir1
    file = FileHelper.find_file( 'File1.def', PATH )
    
    file.should == FILE_1_PATH
    
  end
  
  #
  # Search all paths.
  #
  it "should search all directories" do
    
    # Search for "File2.def", it should be found in test_lib_dir2
    file = FileHelper.find_file( 'File2.def', PATH )
    
    file.should == FILE_2_PATH
    
  end
  
  #
  # Search for definition with no namespaces.
  #
  it "should find definitions by classname" do
    
    # Search for ["File3"]
    file = FileHelper.find_definition( ['File3'], PATH )
    
    file.should == FILE_3_PATH
    
  end
  
  #
  # Search for definition nested under one namespace.
  #
  it "should find definitions with one namespace" do
    
    # Search for ["NS1", "File4"]
    file = FileHelper.find_definition( ['NS1', 'File4'], PATH )
    
    file.should == FILE_4_PATH
    
  end
  
  #
  # Search for definition nested by more than one namespace.
  #
  it "should find definitions with multiple namespaces" do
    
    # Search for ["NS1", "NS2", "File5"]
    file = FileHelper.find_definition( ['NS1', 'NS2', 'File5'], PATH )
    
    file.should == FILE_5_PATH
    
  end
  
end
