################################################################################
# FileFinder.rb
#
# Unit tests for FileFinder.
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

require File.expand_path( 'src/FileFinder.rb' )

include Bob

describe FileFinder do
  before(:all) do
    @original_path = FileFinder.path
    @sample_path = ['.', 'defs', 'decs']
  end
  
  it "should be able to find files on the path"
    # TODO: create a file in the local directory, and one in another directory.
    # Test the order it finds them in.
  
  it "should be able to change the path" do
    FileFinder.path = @sample_path
    FileFinder.path.should == @sample_path
  end
  
  after(:all) do
    FileFinder.path = @original_path
  end
end
