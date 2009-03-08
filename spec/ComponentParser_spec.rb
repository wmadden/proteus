################################################################################
# ComponentParser.rb
#
# Unit tests for ComponentParser.
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

require File.expand_path( 'src/ComponentParser.rb' )

include Bob

describe ComponentParser do
  # Using basic 'Component's, the CP should interpret:
  #   * a scalar as the first child
  #   * a list as the children
  #   * a hash as parameters
  
  before(:all) do
    @scalar = "flat scalar"
    @list = [@scalar, @scalar, @scalar]
    @hash = {:a => @scalar, :b => @scalar, :c => @scalar}
    @hash_children = {:a => @scalar, :b => @scalar, :c => @scalar, 'children' => @list}
  end
  
  it "should create a blank component from nil" do
    component = ComponentParser.parse('Component', nil)
    component.children.length.should == 0
    component.parameters.length.should == 0
  end
  
  it "should interpret a scalar as the first child" do
    component = ComponentParser.parse('Component', @scalar)
    component.children.length.should == 1
    component.children[0].should == @scalar
    component.parameters.length.should == 0
  end
  
  it "should interpret a list as the children" do
    component = ComponentParser.parse('Component', @list)
    component.children.should == @list
    component.parameters.length.should == 0
  end
  
  it "should interpret a hash as the parameters" do
    component = ComponentParser.parse('Component', @hash)
    component.parameters.should == @hash
    component.children.length.should == 0
  end
  
  it "should interpret a hash with 'children' set as the parameters, and the value of 'children' as the children" do
    component = ComponentParser.parse('Component', @hash_children)
    component.children.should == @list
    component.parameters.should == @hash
  end
end
