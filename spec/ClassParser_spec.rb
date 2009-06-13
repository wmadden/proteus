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

require File.expand_path( 'src/ClassParser.rb' )

include Bob


describe ClassParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
  DEF_1 = {
    BAD_NAME_1 => {
    }
  }
  
  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #------------------------------
  #  before(:all)
  #------------------------------
  
  before(:all) do
  end
  
  #------------------------------
  #  after(:all)
  #------------------------------
  
  after(:all) do
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  # Only accept correctly formed definitions.
  #
  # Do not accept:
  #   nil
  #   scalar
  #   list
  #   empty name
  #   malformed name
  #   empty parent name
  #   malformed parent name
  #   hash of scalar
  #   hash of list
  #   hash longer than one element
  # 
  # Accept:
  #   hash of nothing
  #   hash of hash
  #
  
  it "should reject nil"
  
  it "should reject scalar"
  
  it "should reject list"
  
  it "should reject hash longer than one element"
  
  it "should reject missing name"
  
  it "should reject malformed name"
  
  it "should reject empty parent name"
  
  it "should reject malformed parent name"
  
  it "should reject hash of scalar"
  
  it "should reject hash of list"
  
  
  it "should accept valid empty hash"
  
  it "should accept valid hash of properties"
  
  
  it "should parse parent names in the form '> Parent'"
  
  it "should interpret the inner hash as properties"
  
  it "should interpret the 'children' property as children"
  
  
end

