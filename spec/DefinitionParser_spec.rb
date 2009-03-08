################################################################################
# DefinitionParser.rb
#
# Unit tests for DefinitionParser.
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

require File.expand_path( 'src/DefinitionParser.rb' )

include Bob


#
# Imporant functions:
#   * parse_name
#   * get_ancestors
#   * parse_defaults
#   * parse
#   * load
#
describe DefinitionParser do
  before(:all) do
    @params = { 'a' => 'b', 'b' => 'c', 'c' => 'd' }
    @children = [ 'a', 'b', 'c' ]
    @decorators = [ 'dec1', 'dec2', 'dec3' ]
    @template = 'this is the template'
    @sample_def = {'Component' => {
      'parameters' => @params,
      'children' => @children,
      'decorators' => @decorators,
      'template' => @template,
    }}
  end

  it "should be able to get the parent from the name" do
    DefinitionParser.parse_name('SomeComponent < SomeParent').should == 'SomeParent'
    DefinitionParser.parse_name('SomeComponent').should == nil
  end
  
  it "should be able to get ancestors when there are some"
  
  it "should be able to parse default parameters" do
    input = {'Component' => {'parameters' => @params}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.parameters.should == @params
  end
  
  it "should be able to parse default children" do
    input = {'Component' => {'children' => @children}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.children.should == @children
  end
  
  it "should be able to parse default decorators" do
    input = {'Component' => {'decorators' => @decorators}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.decorators.should == @decorators
  end
  
  it "should be able to parse component template" do
    input = {'Component' => {'template' => @template}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.template.should == @template
  end
  
  it "should be able to parse definitions" do
    result = DefinitionParser.parse('Component', @sample_def)
    
    result.parameters.should == @params
    result.children.should == @children
    result.decorators.should == @decorators
    result.template.should == @template
  end
  
  it "should be able to parse children which are components"
  
  it "should be able to parse parameters which are components"
  
  it "should be able to load definitions"
end
