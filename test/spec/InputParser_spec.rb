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

require File.expand_path( 'lib/InputParser.rb' )

include Proteus


describe InputParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
  # Nil
  
  @@NIL = nil
  
  # Scalars
  
  @@INVALID_SCALAR_COMPONENT = "not a component"
  @@INVALID_SCALAR_COMPONENT2 = "Not A Component"
  @@INVALID_SCALAR_COMPONENT3 = "Definitely Not Component"
  
  @@KNOWN_SCALAR_COMPONENT = "TestComponent1"
  @@KNOWN_SCALAR_COMPONENT2 = "TestComponent3"
  
  @@UNKNOWN_SCALAR_COMPONENT = "TestComponent2"
  
  @@COMPONENT_PROPERTIES = {
    "prop1" => "val1",
    "prop2" => "val2",
    "prop3" => @@KNOWN_SCALAR_COMPONENT
  }
  
  # Hashes
  
  @@KNOWN_COMPONENT_HASH = {
    @@KNOWN_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES
  }
  
  @@KNOWN_COMPONENT_HASH2 = {
    @@KNOWN_SCALAR_COMPONENT2 => @@COMPONENT_PROPERTIES
  }
  
  @@INVALID_COMPONENT_HASH = {
    @@INVALID_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES
  }
  
  @@INVALID_COMPONENT_HASH2 = {
    @@INVALID_SCALAR_COMPONENT2 => @@COMPONENT_PROPERTIES
  }
  
  @@UNKNOWN_COMPONENT_HASH = {
    @@UNKNOWN_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES
  }
  
  @@LONG_COMPONENT_HASH = {
    @@KNOWN_SCALAR_COMPONENT => @@COMPONENT_PROPERTIES,
    @@KNOWN_SCALAR_COMPONENT2 => @@COMPONENT_PROPERTIES
  }
  
  # Arrays
  
  @@EMPTY_ARRAY = []
  
  @@NONC_SCALAR_ARRAY = [ @@INVALID_SCALAR_COMPONENT ]
  
  @@COMP_SCALAR_ARRAY = [ @@KNOWN_SCALAR_COMPONENT ]
  
  @@MANY_NONC_SCALAR_ARRAY = [
    @@INVALID_SCALAR_COMPONENT,
    @@INVALID_SCALAR_COMPONENT2,
    @@INVALID_SCALAR_COMPONENT3
  ]
  
  @@MANY_COMP_SCALAR_ARRAY = [
    @@KNOWN_SCALAR_COMPONENT,
    @@KNOWN_SCALAR_COMPONENT2
  ]
  
  @@MIXED_SCALAR_ARRAY = [
    @@INVALID_SCALAR_COMPONENT,
    @@KNOWN_SCALAR_COMPONENT,
    @@INVALID_SCALAR_COMPONENT2,
    @@KNOWN_SCALAR_COMPONENT2
  ]
  
  @@NONC_HASH_ARRAY = [ @@INVALID_COMPONENT_HASH ]
  @@COMP_HASH_ARRAY = [ @@KNOWN_COMPONENT_HASH ]
  
  @@MANY_NONC_HASH_ARRAY = [
    @@INVALID_COMPONENT_HASH,
    @@INVALID_COMPONENT_HASH2,
    @@INVALID_COMPONENT_HASH
  ]
  @@MANY_COMP_HASH_ARRAY = [
    @@KNOWN_COMPONENT_HASH,
    @@KNOWN_COMPONENT_HASH2,
    @@KNOWN_COMPONENT_HASH
  ]
  
  @@MIXED_HASH_ARRAY = [
    @@INVALID_COMPONENT_HASH,
    @@KNOWN_COMPONENT_HASH,
    @@INVALID_COMPONENT_HASH2,
    @@KNOWN_COMPONENT_HASH2
  ]
  
  @@MIXED_ARRAY = [
    @@KNOWN_SCALAR_COMPONENT,
    @@KNOWN_COMPONENT_HASH,
    @@INVALID_SCALAR_COMPONENT,
    @@INVALID_COMPONENT_HASH
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
    @definition_helper.path = "test/spec/lib"
    
    @definition_parser.definition_helper = @definition_helper
    
    # Input parser
    @input_parser = InputParser.new
    @input_parser.instance_parser = @instance_parser
    @input_parser.definition_helper = @definition_helper
    
    @definition_parser.input_parser = @input_parser
    
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Helper functions
  #  
  #-----------------------------------------------------------------------------
  
  def check_hash_parsed( hash )
    hash.is_a?( Hash ).should == true
    hash.length.should == 1
    
    check_properties_parsed( hash.values[0] )
  end
  
  def check_properties_parsed( hash )
    hash.length.should == 3
    
    hash["prop1"].should == "val1"
    hash["prop2"].should == "val2"
    hash["prop3"].is_a?( ComponentInstance ).should == true
    hash["prop3"].kind.name.should == @@KNOWN_SCALAR_COMPONENT
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  # Parse nil:
  #   nil
  
  it "nil -> nil" do
    result = @input_parser.parse_yaml( @@NIL )
    result.should == @@NIL
  end
  
  
  # Parse scalar:
  #   invalid component name -> scalar
  #   valid, known component name -> component instance
  #   valid but unknown component name -> scalar
  
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
  #   length 1 with valid, known component name -> component instance
  #   length 1 with valid, unknown component name -> hash of parsed values
  #   length 1 with invalid component name -> hash of parsed values
  #   length > 1 -> hash of parsed values
  
  it "length 1 with valid, known component name -> component instance" do
    result = @input_parser.parse_yaml( @@KNOWN_COMPONENT_HASH )
    
    result.is_a?( ComponentInstance ).should == true
    result.kind.name.should == @@KNOWN_SCALAR_COMPONENT
  end
  
  
  it "length 1 with valid, unknown component name -> hash of parsed values" do
    result = @input_parser.parse_yaml( @@UNKNOWN_COMPONENT_HASH )
    
    check_hash_parsed( result )
  end
  
  
  it "length 1 with invalid component name -> hash of parsed values" do
    result = @input_parser.parse_yaml( @@INVALID_COMPONENT_HASH )
    
    check_hash_parsed( result )
  end
  
  
  it "length > 1 -> hash of parsed values" do
    result = @input_parser.parse_yaml( @@LONG_COMPONENT_HASH )
    
    result.length.should == 2
    
    result.keys[0].should == @@KNOWN_SCALAR_COMPONENT
    result.keys[1].should == @@KNOWN_SCALAR_COMPONENT2
    
    check_properties_parsed( result.values[0] )
    check_properties_parsed( result.values[1] )
  end
  
  
  # Parse arrays:
  #   empty array -> empty array
  #   array of single, non-component scalar -> array of parsed values
  #   array of single, component scalar -> array of component instance
  #   array of many non-component scalars -> array of parsed values
  #   array of many component scalars -> array of component instances
  #   array of mixed scalars -> array of parsed values
  #   array of single, non-component hash -> array of parsed hash
  #   array of single, component hash -> array of component instance
  #   array of many non-component hashes -> array of parsed hashes
  #   array of many component hashes -> array of component instances
  #   array of mixed hashes -> array of parsed hashes
  #   array of mixed scalars and hashes -> array of parsed values
  
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
    result.length.should == 1
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
  end
  
  
  it "array of many non-component scalars -> array of parsed values" do
    result = @input_parser.parse_yaml( @@MANY_NONC_SCALAR_ARRAY )
    result.should == @@MANY_NONC_SCALAR_ARRAY
  end
  
  
  it "array of many component scalars -> array of component instances" do
    result = @input_parser.parse_yaml( @@MANY_COMP_SCALAR_ARRAY )
    
    result.length.should == 2
    
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT2
  end
  
  
  it "array of mixed scalars -> array of parsed values" do
    result = @input_parser.parse_yaml( @@MIXED_SCALAR_ARRAY )
    
    result.length.should == 4
    
    result[0].should == @@INVALID_SCALAR_COMPONENT
    
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    result[2].should == @@INVALID_SCALAR_COMPONENT2
    
    result[3].is_a?( ComponentInstance ).should == true
    result[3].kind.name.should == @@KNOWN_SCALAR_COMPONENT2
  end
  
  
  it "array of single, non-component hash -> array of parsed hash" do
    result = @input_parser.parse_yaml( @@NONC_HASH_ARRAY )
    result.length.should == 1
    result[0].is_a?( Hash ).should == true
    
    check_hash_parsed( result[0] )
  end
  
  
  it "array of single, component hash -> array of component instance" do
    result = @input_parser.parse_yaml( @@COMP_HASH_ARRAY )
    result.length.should == 1
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
  end
  
  
  it "array of many non-component hashes -> array of parsed hashes" do
    result = @input_parser.parse_yaml( @@MANY_NONC_HASH_ARRAY )
    
    result.length.should == 3
    
    result[0].is_a?( Hash ).should == true
    result[1].is_a?( Hash ).should == true
    result[2].is_a?( Hash ).should == true
    
    check_hash_parsed( result[0] )
    check_hash_parsed( result[1] )
    check_hash_parsed( result[2] )
  end
  
  
  it "array of many component hashes -> array of component instances" do
    result = @input_parser.parse_yaml( @@MANY_COMP_HASH_ARRAY )
    
    result.length.should == 3
    
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT2
    result[2].is_a?( ComponentInstance ).should == true
    result[2].kind.name.should == @@KNOWN_SCALAR_COMPONENT
  end
  
  
  it "array of mixed hashes -> array of parsed hashes" do
    result = @input_parser.parse_yaml( @@MIXED_HASH_ARRAY )
    
    result.length.should == 4
    
    check_hash_parsed( result[0] )
    
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    check_hash_parsed( result[2] )
    
    result[3].is_a?( ComponentInstance ).should == true
    result[3].kind.name.should == @@KNOWN_SCALAR_COMPONENT2
    
  end
  
  
  it "array of mixed scalars and hashes -> array of parsed values" do
    result = @input_parser.parse_yaml( @@MIXED_ARRAY )
    
    result.length.should == 4
    
    result[0].is_a?( ComponentInstance ).should == true
    result[0].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    result[1].is_a?( ComponentInstance ).should == true
    result[1].kind.name.should == @@KNOWN_SCALAR_COMPONENT
    
    result[2].should == @@INVALID_SCALAR_COMPONENT
    
    check_hash_parsed( result[3] )
    
  end
  
  
end
