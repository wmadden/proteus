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

require File.expand_path( 'src/FileFinder.rb' )
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
    # Set up paths
    @default_file_path = FileFinder.path
    FileFinder.path += ['spec/defs']
        
    @parameters = { 'a' => 'b', 'b' => 'c', 'c' => 'd' }
    @children = [ 'a', 'b', 'c' ]
    @decorators = [ 'dec1', 'dec2', 'dec3' ]
    @template = 'this is the template'
    @sample_def = {'Component' => {
      'parameters' => @parameters,
      'children' => @children,
      'decorators' => @decorators,
      'template' => @template,
    }}
    
    @default_children = @children
    @default_parameters = @parameters
    @default_decorators = [] # NYI
    @default_template = @template
  end

  def clear_def_hash
    # Empty the loaded definitions hash (HACKY)
    DefinitionParser.class_eval("@@definitions = {}")
  end

  after(:all) do
    FileFinder.path = @default_file_path
    clear_def_hash
  end

  it "should be able to get the parent from the name" do
    DefinitionParser.parse_name('SomeComponent < SomeParent').should == 'SomeParent'
    DefinitionParser.parse_name('SomeComponent').should == nil
  end
  
  it "should be able to get ancestors when there are some"
  
  it "should be able to parse default parameters" do
    input = {'Component' => {'parameters' => @parameters}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.parameters.should == @parameters
  end
  
  it "should be able to parse default children" do
    input = {'Component' => {'children' => @children}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.children.should == @children
  end
  
  it "should be able to parse default decorators"# do
#    input = {'Component' => {'decorators' => @decorators}}
#    result = DefinitionParser.parse('Component', input)
#    result.decorators.should == @decorators
#  end
  
  it "should be able to parse component template" do
    input = {'Component' => {'template' => @template}}
    
    result = DefinitionParser.parse('Component', input)
    
    result.template.should == @template
  end
  
  it "should be able to parse definitions" do
    result = DefinitionParser.parse('Component', @sample_def)
    
    result.parameters.should == @parameters
    result.children.should == @children
#    result.decorators.should == @decorators
    result.template.should == @template
  end
  
  it "should load the default definition from file" do
    clear_def_hash
    # Load the default definition
    default_def = DefinitionParser.load('Component')
    
    default_def.children.should == @default_children
    default_def.parameters.should == @default_parameters
    default_def.decorators.should == @default_decorators
    default_def.template.should == @default_template
  end
  
  it "should not permit a definition to be its own parent" do
    success = true
    begin
      DefinitionParser.parse('SomeDef', 'SomeDef < SomeDef')
      success = false
    rescue RecursiveDefinition
    end
    
    success.should == true
  end
  
  it "should assume a component inherits from Component if undefined" do
    result = DefinitionParser.parse('SomeComponent', 'SomeComponent')
    result.parent.should == 'Component'
  end
  
  it "should calculate ancestors correctly" do
    # A < Component
    a = DefinitionParser.load('A')
    # B < A
    b = DefinitionParser.parse('B', 'B < A')
    # B.ancestors == ['B', 'A', 'Component']?
    b.ancestors.should == ['B', 'A', 'Component']
  end
  
  it "should not permit recursive components" do
    # C < B
    # B < C
    success = true
    begin
      b = DefinitionParser.load('B')
      success = false
    rescue RecursiveDefinition
    end
    success.should == true
  end
  
  it "should fail if it can't find the file or the class" do
    success = true
    begin
      DefinitionParser.load('NotARealDefinition')
      success = false
    rescue UnknownDefinition
    end
    success.should == true
  end
  
end
