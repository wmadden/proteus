################################################################################
# ParserHelper.rb
#
# Unit tests for ParserHelper.
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

require File.expand_path( 'src/ParserHelper.rb' )
require File.expand_path( 'src/Component.rb' )

include Bob

# Important functions
#   * get_class
#   * is_scalar?
#   * is_component?
class SubComponent < Component
end

class NotComponent
end

FalseKlass = false

describe ParserHelper do
  it "should be able to get known classes"
  it "should be able to get classes on the path"
  it "should handle non-existant classes gracefully" do
    ParserHelper.get_class('NonExistantClass').nil?.should == true
    ParserHelper.get_class('FalseKlass').nil?.should == true
  end
  
  it "should recognize component names" do
    ParserHelper::ComponentRegex.should =~ 'Component'
    ParserHelper::ComponentRegex.should =~ 'CamelcaseComponent'
    ParserHelper::ComponentRegex.should_not =~ 'notcomponent'
    ParserHelper::ComponentRegex.should_not =~ 'Not A Component'
  end
  
  it "should be able to test if something's a scalar" do
    ParserHelper.is_scalar?(Hash.new).should == false
    ParserHelper.is_scalar?(Array.new).should == false
    ParserHelper.is_scalar?(nil).should == false
    
    ParserHelper.is_scalar?('string').should == true
    ParserHelper.is_scalar?(1337).should == true
  end
  
  it "should be able to tell if something's a component" do
    ParserHelper.is_component?(Component).should == true
    ParserHelper.is_component?(SubComponent).should == true
    ParserHelper.is_component?(NotComponent).should == false
  end
end
