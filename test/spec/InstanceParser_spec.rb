################################################################################
# (C) Copyright 2009 William Madden
# 
# This file is part of Proteus.
# 
# Proteus is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Proteus is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# Proteus.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require File.expand_path( 'lib/InstanceParser.rb' )

include Proteus


describe InstanceParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
  @@HASH_1 = {
    "property1" => "value1",
    "property2" => "value2",
    "property3" => "value3"
  }
  
  @@CHILDREN_1 = [
    "child 1",
    "child 2",
    "child 3"
  ]
  
  @@HASH_2 = {
    "property1" => "value1",
    "property2" => "value2",
    "property3" => "value3",
    "children" => @@CHILDREN_1
  }
  
  @@SCALAR_1 = "child 1"
  
  @@CHILDREN_2 = [ @@SCALAR_1 ]
  
  @@LIST_1 = @@CHILDREN_1
  
  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #------------------------------
  #  before(:all)
  #------------------------------
  
  before(:all) do
    @instance_parser = InstanceParser.new
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  
  it "should interpret a hash as properties" do
    
    comp = @instance_parser.parse_yaml( @@HASH_1 )
    comp.properties.should == @@HASH_1
    
  end
  
  
  it "should interpret a 'children' property as children" do
    
    comp = @instance_parser.parse_yaml( @@HASH_2 )
    
    comp.children.should == @@CHILDREN_1
    comp.properties.should == @@HASH_1
    
  end
  
  
  it "should interpret a list as children" do
    
    comp = @instance_parser.parse_yaml( @@LIST_1 )
    
    comp.properties.should == {}
    comp.children.should == @@CHILDREN_1
    
  end
  
  
  it "should interpret a scalar as a single child" do
    
    comp = @instance_parser.parse_yaml( @@SCALAR_1 )
    
    comp.children.should == @@CHILDREN_2
    comp.properties.should == {}
    
  end
  
  
  it "should interpret nil as a blank component" do
    
    comp = @instance_parser.parse_yaml( nil )
    
    comp.properties.should == {}
    comp.children.should == []
    
  end
  
end
