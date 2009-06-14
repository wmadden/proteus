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

require File.expand_path( 'src/InputParser.rb' )

include Bob


describe InputParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
  NIL = nil
  
  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #------------------------------
  #  before(:all)
  #------------------------------
  
  before(:all) do
    @input_parser = InputParser.new
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
  
  # Parse nil:
  #  nil
  
  it "nil -> nil" do
    result = @input_parser.parse_yaml( NIL )
    result.should == NIL
  end
  
  
  # Parse scalar:
  #  invalid component name -> scalar
  #  valid, known component name -> component instance
  #  valid but unknown component name -> scalar
  
  it "invalid component name -> scalar"
  
  
  it "valid, known component name -> component instance"
  
  
  it "valid but unknown component name -> scalar"
  
  # Parse hash:
  #  length 1 with valid, know component name -> component instance
  #  length 1 with valid, unknown component name -> hash of parsed values
  #  length 1 with invalid component name -> hash of parsed values
  #  length > 1 -> hash of parsed values
  
  it "length 1 with valid, know component name -> component instance"
  
  
  it "length 1 with valid, unknown component name -> hash of parsed values"
  
  
  it "length 1 with invalid component name -> hash of parsed values"
  
  
  it "length > 1 -> hash of parsed values"
  
  
  # Parse arrays:
  #  empty array -> empty array
  #  array of single, non-component scalar -> array of parsed values
  #  array of single, component scalar -> array of component instance
  #  array of many non-component scalars -> array of parsed values
  #  array of many component scalars -> array of component instances
  #  array of mixed scalars -> array of parsed values
  #  array of single, non-component hash -> array of parsed hash
  #  array of single, component hash -> array of component instance
  #  array of many non-component hashes -> array of parsed hashes
  #  array of many component hashes -> array of component instances
  #  array of mixed hashes -> array of parsed hashes
  #  array of mixed scalars and hashes -> array of parsed values
  
  it "empty array -> empty array"
  
  
  it "array of single, non-component scalar -> array of parsed values"
  
  
  it "array of single, component scalar -> array of component instance"
  
  
  it "array of many non-component scalars -> array of parsed values"
  
  
  it "array of many component scalars -> array of component instances"
  
  
  it "array of mixed scalars -> array of parsed values"
  
  
  it "array of single, non-component hash -> array of parsed hash"
  
  
  it "array of single, component hash -> array of component instance"
  
  
  it "array of many non-component hashes -> array of parsed hashes"
  
  
  it "array of many component hashes -> array of component instances"
  
  
  it "array of mixed hashes -> array of parsed hashes"
  
  
  it "array of mixed scalars and hashes -> array of parsed values"
  
  
end
