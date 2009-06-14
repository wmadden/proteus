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


describe DefinitionParser do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------

  class DummyInputParser
    
    attr_accessor :called, :inputs
    
    def initialize
      @inputs = []
    end
    
    def parse_yaml( yaml )
      @called = true
      @inputs.push( yaml )
    end
    
  end

  class DummyClassParser
    
    attr_accessor :called, :yaml, :component_class
    
    def initialize()
      @called = false
    end
    
    def parse_yaml( yaml, component_class )
      @called = true
      
      @yaml = yaml
      @component_class = component_class
      
      component_class.name = "SomeComponent"
      component_class.parent = "SomeParent"
      component_class.children = [
        "child1",
        "child2",
        "child3"
      ]
      component_class.properties = {
        "prop1" => "value1",
        "prop2" => "value2",
        "prop3" => "value3"
      }
      
      return component_class
    end
    
  end

  class DummyDefinitionHelper
    
    attr_accessor :called, :class_id
    
    def get_class( class_id )
      @called = true
      @class_id = class_id
      
      return nil
    end
    
  end
  
  @@PARENT_NAME = "SomeParent"
  @@COMPONENT_NAME = "SomeComponent"
  @@COMPONENT_CHILDREN = [
    "child1",
    "child2",
    "child3"
  ]
  @@COMPONENT_PROPS = {
    "prop1" => "value1",
    "prop2" => "value2",
    "prop3" => "value3"
  }

  @@COMPONENT_FULL_PROPS = {
    "prop1" => "value1",
    "prop2" => "value2",
    "prop3" => "value3",
    "children" => @@COMPONENT_CHILDREN
  }

  @@EXPECTED_INPUTS = [
    "value1",
    "value2",
    "value3",
    "child1",
    "child2",
    "child3"
  ]

  @@DEFINITION = {
    @@COMPONENT_NAME + " < " + @@PARENT_NAME => @@COMPONENT_FULL_PROPS
  }
  
  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #------------------------------
  #  before(:each)
  #------------------------------
  
  before(:each) do
    @dummy_dh = DummyDefinitionHelper.new
    @dummy_cp = DummyClassParser.new
    @dummy_ip = DummyInputParser.new
    
    @definition_parser = 
      DefinitionParser.new( @dummy_dh, @dummy_cp, @dummy_ip )
  end
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  it "should use the class parser to parse the file" do
    
    component_class = ComponentClass.new
    
    @definition_parser.parse_yaml( @@DEFINITION, component_class )
    
    @dummy_cp.called.should == true
    @dummy_cp.component_class.should == component_class
    @dummy_cp.yaml.should == @@DEFINITION
    
  end
  
  it "should use the input parser to parse the class's values" do
    
    component_class = ComponentClass.new
    
    @definition_parser.parse_yaml( @@DEFINITION, component_class )
    
    @dummy_ip.called.should == true
    @dummy_ip.inputs.should == @@EXPECTED_INPUTS
    
  end
  
  it "should use the definition helper to get the parent" do
    
    component_class = ComponentClass.new
    
    @definition_parser.parse_yaml( @@DEFINITION, component_class )
    
    @dummy_dh.called.should == true
    @dummy_dh.class_id.should == @@PARENT_NAME
    
  end
  
end

