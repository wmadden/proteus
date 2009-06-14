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


require File.expand_path( 'src/DefinitionHelper.rb' )
require File.expand_path( 'src/exceptions.rb' )

include Bob


describe DefinitionHelper do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------
  
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
    @definition_helper.current_ns = "NS1"
    
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
  
  it "should use the current namespace if no namespace is given" do
    result = @definition_helper.get_class( ["TestComponent4"] )
    result.name.should == "TestComponent4"
  end
  
  
  it "should use the given namespace if present" do
    result = @definition_helper.get_class( ["NS2", "TestComponent6"] )
    result.name.should == "TestComponent6"
  end
  
  
  it "should load classes that haven't already been loaded"
  
  
  it "should return classes that have already been loaded" do
    result = @definition_helper.get_class( ["TestComponent4"] )
    result.name.should == "TestComponent4"
    
    result2 = @definition_helper.get_class( ["TestComponent4"] )
    result2.should == result
  end
  
  
  it "should fail if it can't find the class definition" do
    begin
      result = @definition_helper.get_class( ["TestComponent7"] )
    rescue Exceptions::DefinitionUnavailable
      success = true
    end
    
    success.should == true
  end
  
  
  it "should not permit recursive classes" do
    begin
      result = @definition_helper.get_class( ["TestComponent8"] )
    rescue Exceptions::RecursiveDefinition
      success1 = true
    end
    
    begin
      result = @definition_helper.get_class( ["TestComponent9"] )
    rescue Exceptions::RecursiveDefinition
      success2 = true
    end
    
    success1.should == true
    success2.should == true
  end
  
  
end
