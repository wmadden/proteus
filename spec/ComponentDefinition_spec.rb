################################################################################
# ComponentDefinition.rb
#
# Unit tests for ComponentDefinition.
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

require File.expand_path( 'src/ComponentDefinition.rb' )
require File.expand_path( 'src/Component.rb' )

include Bob

#
# Important functions:
#   * Constructor
#   * merge_defaults
#   * instantiate
#
describe ComponentDefinition do
  before(:all) do
    @sample_parameters = {:a => :b, :b => :c, :c => :d}
    @sample_children = [:child1, :child2, :child3]
    @sample_template = "sample template"
    @sample_decorators = [:dec1, :dec2, :dec3]
    
    @new_parameters = {:d => :e, :e => :f, :f => :g}
    @new_children = [:child4, :child5, :child6]
    @new_decorators = [:dec4, :dec5, :dec6]
    @new_template = "new template"
    
    @sample_defaults = {
      :children => @sample_children,
      :parameters => @sample_parameters,
      :template => @sample_template,
      :decorators => @sample_decorators
    }
    
    @kind = 'SomeComponent'
    @parent = 'Component'
    @ancestors = [@kind, @parent]
    @concrete_class = Component
    
    @new_defaults = {
      :children => @new_children,
      :parameters => @new_parameters,
      :template => @new_template,
      :decorators => @new_decorators
    }
  end

  it "should be correctly initialized from a defaults hash" do
    definition = ComponentDefinition.new(@kind, @sample_defaults, @ancestors, @concrete_class)

    definition.kind.should == @kind
    definition.ancestors.should == @ancestors
    definition.parent.should == @parent
    definition.defaults.should == @sample_defaults
    definition.parameters.should == @sample_parameters
    definition.children.should == @sample_children
    definition.decorators.should == @sample_decorators
    definition.template.should == @sample_template
  end
  
  it "should merge defaults intelligently" do
    # Children overwrite defaults
    # Parameters merge (using Hash.merge)
    # Decorators overwrite
    # Template overwrites
    child_defs = @new_defaults
    parent_defs = @sample_defaults
    
    result = ComponentDefinition.merge_defaults( child_defs, parent_defs )
    result[:children].should == @new_children
    result[:parameters].should == @sample_parameters.merge(@new_parameters)
    result[:decorators].should == @new_decorators
    result[:template].should == @new_template
  end
  
  it "should instantiate components with its defaults" do
    definition = ComponentDefinition.new(@kind, @sample_defaults, @ancestors, @concrete_class)
    component = definition.instantiate
    
    component.template.should == definition.template
    component.children.should == definition.children
    component.decorators.should == definition.decorators
    component.kind.should == definition.kind
    component.parameters.should == definition.parameters
  end
  
  it "should instantiate components with merged defaults" do
    definition = ComponentDefinition.new(@kind, @sample_defaults, @ancestors, @concrete_class)
    component = definition.instantiate(@new_parameters, @new_children, @new_template, @new_decorators)
    
    component.template.should == @new_template
    component.children.should == @new_children
    component.decorators.should == @new_decorators
    component.kind.should == definition.kind
    component.parameters.should == @sample_parameters.merge(@new_parameters)
  end
end























