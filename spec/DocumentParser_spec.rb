################################################################################
# DocumentParser.rb
#
# Unit tests for DocumentParser.
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

require File.expand_path( 'src/DocumentParser.rb' )

include Bob

describe DocumentParser do
  before(:all) do
    # Set up paths
    @default_file_path = FileFinder.path
    FileFinder.path += ['spec/defs']
  end

  it "should be able to parse a hash"
  it "should be able to parse a list"
  it "should be able to parse a scalar"
  it "should be able to load a file" do
    
  end
  
  after(:all) do
    FileFinder.path = @default_file_path
  end
end
