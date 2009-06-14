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
  
  @@NIL = nil
  
  @@INVALID_SCALAR_COMPONENT = "invalid component"
  
  @@KNOWN_SCALAR_COMPONENT = "TestComponent1"
  @@KNOWN_SCALAR_COMPONENT2 = "TestComponent3"
  
  @@UNKNOWN_SCALAR_COMPONENT = "TestComponent2"
  
  @@COMPONENT_PROPERTIES = {
    "prop1" => "val1",
    "prop2" => "val2",
    "prop3" => "val3"
  }
  @@KNOWN_COMPONENT_HASH = {
    @@KNOWN_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES
  }
  @@INVALID_COMPONENT_HASH = {
    @@INVALID_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES
  }
  
  @@EMPTY_ARRAY = []
  @@NONC_SCALAR_ARRAY = [ @@INVALID_SCALAR_COMPONENT ]
  @@COMP_SCALAR_ARRAY = [ @@KNOWN_SCALAR_COMPONENT ]
  @@MANY_NONC_SCALAR_ARRAY = [
    "not a component",
    "NotAComponent",
    "Definitely Not Component"
  ]
  @@MANY_COMP_SCALAR_ARRAY = [
    @@KNOWN_SCALAR_COMPONENT,
    @@KNOWN_SCALAR_COMPONENT2
  ]
  @@MIXED_SCALAR_ARRAY = [
    "not a component",
    @@KNOWN_SCALAR_COMPONENT,
    "NotAComponent",
    @@KNOWN_SCALAR_COMPONENT2
  ]
  
  
  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #------------------------------
  #  before(:all)
  #------------------------------
  
  before(:all) do
    
    # Instance parser
    @instance_parser = InstanceParser.new
    
    # Class parser
    @class_parser = ClassParser.new
    
    # Definition parser
    @definition_parser = DefinitionParser.new
    @definition_parser.class_parser = @class_parser
    
    # Definition helper
    @definition_helper = DefinitionHelper.new
    @definition_helper.definition_parser = @definition_parser
    @definition_helper.path = "spec/lib"
    
    @definition_parser.definition_helper = @definition_helper
    
    # Input parser
    @input_parser = InputParser.new
    @input_parser.instance_parser = @instance_parser
    @input_parser.definition_helper = @definition_helper
    
    @definition_parser.input_parser = @input_parser
    
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  # Parse nil:
  #  nil
  
  it "nil -> nil" do
    result = @input_parser.parse_yaml( @@NIL )
    result.should == @@NIL
  end
  
  
  # Parse scalar:
  #  invalid component name -> scalar
  #  valid, known component name -> component instance
  #  valid but unknown component name -> scalar
  
  it "invalid component name -> scalar" do
    result = @input_parser.parse_yaml( @@INVALID_SCALAR_COMPONENT )
    result.should == @@INVALID_SCALAR_COMPONENT
  end
  
  it "valid, known component name -> component instance" do
    result = @input_parser.parse_yaml( @@KNOWN_SCALAR_COMPONENT )
    result.is_a?( ComponentInstance ).should == true
  end
  
  
  it "valid but unknown component name -> scalar" do
    result = @input_parser.parse_yaml( @@UNKNOWN_SCALAR_COMPONENT )
    result.should == @@UNKNOWN_SCALAR_COMPONENT
  end
  
  
  # Parse hash:
  #  length 1 with valid, known component name -> component instance
  #  length 1 with valid, unknown component name -> hash of parsed values
  #  length 1 with invalid component name -> hash of parsed values
  #  length > 1 -> hash of parsed values
  
  it "length 1 with valid, known component name -> component instance" do
    result = @input_parser.parse_yaml( @@KNOWN_COMPONENT_HASH )
    result.is_a?( ComponentInstance ).should == true
  end
  
  
  it "length 1 with valid, unknown component name -> hash of parsed values"# do
#    result = @input_parser.parse_yaml( @@UNKNOWN_COMPONENT_HASH )
#    result.should == @@UNKNOWN_COMPONENT_HASH
#  end
  
  
  it "length 1 with invalid component name -> hash of parsed values" do
    # TODO
    result = @input_parser.parse_yaml( @@INVALID_COMPONENT_HASH )
    result.should == @@INVALID_COMPONENT_HASH
  end
  
  
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
  
  it "empty array -> empty array" do
    result = @input_parser.parse_yaml( @@EMPTY_ARRAY )
    result.should == @@EMPTY_ARRAY
  end
  
  
  it "array of single, non-component scalar -> array of parsed values" do
    result = @input_parser.parse_yaml( @@NONC_SCALAR_ARRAY )
    result.should == @@NONC_SCALAR_ARRAY
  end
  
  
  it "array of single, component scalar -> array of component instance" do
    result = @input_parser.parse_yaml( @@COMP_SCALAR_ARRAY )
    result[0].is_a?( ComponentInstance ).should == true
  end
  
  
  it "array of many non-component scalars -> array of parsed values" do
    result = @input_parser.parse_yaml( @@MANY_NONC_SCALAR_ARRAY )
    result.should == @@MANY_NONC_SCALAR_ARRAY
  end
  
  
  it "array of many component scalars -> array of component instances" do
    result = @input_parser.parse_yaml( @@MANY_COMP_SCALAR_ARRAY )
    
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT2
  end
  
  
  it "array of mixed scalars -> array of parsed values"
  
  
  it "array of single, non-component hash -> array of parsed hash"
  
  
  it "array of single, component hash -> array of component instance"
  
  
  it "array of many non-component hashes -> array of parsed hashes"
  
  
  it "array of many component hashes -> array of component instances"
  
  
  it "array of mixed hashes -> array of parsed hashes"
  
  
  it "array of mixed scalars and hashes -> array of parsed values"
  
  
end
