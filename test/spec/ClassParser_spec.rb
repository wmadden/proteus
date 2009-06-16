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

require File.expand_path( 'lib/ClassParser.rb' )

include Bob


describe ClassParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
  @@NIL = nil
  
  @@SCALAR_1 = "some scalar"
  
  @@LIST_1 = [ "a", "b", "c" ]
  
  @@VALID_NAME = "SomeComponent"
  
  @@VALID_PARENT = "ParentComponent"
  
  @@LONG_HASH = {
    "key1" => "value1",
    "key2" => "value2"
  }
  
  @@HASH_MISSING_NAME = {
    "" => {}
  }
  
  @@HASH_BAD_NAME = {
    "this name is invalid" => {}
  }
  
  @@HASH_MISSING_PARENT = {
    @@VALID_NAME + " < " => {}
  }
  
  @@HASH_BAD_PARENT = {
    @@VALID_NAME + " < bad parent" => {}
  }
  
  @@HASH_OF_NIL = {
    @@VALID_NAME => @@NIL
  }
  
  @@HASH_OF_SCALAR = {
    @@VALID_NAME => @@SCALAR_1
  }
  
  @@HASH_OF_LIST = {
    @@VALID_NAME => @@LIST_1
  }
  
  @@HASH_OF_HASH = {
    @@VALID_NAME => {}
  }
  
  @@PROPERTIES = {
    "property1" => "value1",
    "property2" => "value2",
    "property3" => "value3",
  }
  
  @@CHILDREN = [
    "child1",
    "child2",
    "child3"
  ]
  
  @@PROPERTIES_WITH_CHILDREN = {
    "property1" => "value1",
    "property2" => "value2",
    "property3" => "value3",
    "children" => @@CHILDREN
  }
  
  @@HASH_OF_PROPS = {
    @@VALID_NAME => @@PROPERTIES
  }
  
  @@HASH_WITH_PARENT = {
    @@VALID_NAME + " < " + @@VALID_PARENT => {}
  }
  
  @@HASH_WITH_CHILDREN = {
    @@VALID_NAME => @@PROPERTIES_WITH_CHILDREN
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
    @class_parser = ClassParser.new()
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
  
  it "should reject nil" do
    begin
      @class_parser.parse_yaml( @@NIL )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject scalar" do
    begin
      @class_parser.parse_yaml( @@SCALAR_1 )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject list" do
    begin
      @class_parser.parse_yaml( @@LIST_1 )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject hash longer than one element" do
    begin
      @class_parser.parse_yaml( @@LONG_HASH )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject missing name" do
    begin
      @class_parser.parse_yaml( @@HASH_MISSING_NAME )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject malformed name" do
    begin
      @class_parser.parse_yaml( @@HASH_BAD_NAME )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject empty parent name" do
    begin
      @class_parser.parse_yaml( @@HASH_MISSING_PARENT )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject malformed parent name" do
    begin
      @class_parser.parse_yaml( @@HASH_BAD_PARENT )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject hash of scalar" do
    begin
      @class_parser.parse_yaml( @@HASH_OF_SCALAR )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  it "should reject hash of list" do
    begin
      @class_parser.parse_yaml( @@HASH_OF_LIST )
    rescue Exceptions::DefinitionMalformed
      success = true
    end
    
    success.should == true
  end
  
  
  
  it "should accept valid empty hash" do
    
    result = @class_parser.parse_yaml( @@HASH_OF_NIL )
    
  end
  
  
  it "should accept a hash of a hash" do
    
    result = @class_parser.parse_yaml( @@HASH_OF_HASH )
    
  end
  
  
  it "should parse names in the form 'Name < Parent'" do
    
    result = @class_parser.parse_yaml( @@HASH_WITH_PARENT )
    
    result.name.should == @@VALID_NAME
    result.parent.should == @@VALID_PARENT
    
  end
  
  
  it "should interpret the inner hash as properties" do
    
    result = @class_parser.parse_yaml( @@HASH_OF_PROPS )
    
    result.properties.should == @@PROPERTIES
    
  end
  
  it "should interpret the 'children' property as children" do
    
    result = @class_parser.parse_yaml( @@HASH_WITH_CHILDREN )
    
    result.children.should == @@CHILDREN
    result.properties.should == @@PROPERTIES
    
  end
  
  
end

