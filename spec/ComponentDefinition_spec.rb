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

require 'src/ComponentDefinition.rb'

include Bob

#
# Important functions:
#   * Constructor
#   * merge_defaults
#   * instantiate
#
describe ComponentDefinition do
  before(:all) do
    @sample_params = {:a => :b, :b => :c, :c => :d}
    @sample_children = [:child1, :child2, :child3]
    @sample_template = "sample template"
    @sample_decorators = [:dec1, :dec2, :dec3]
    
    @sample_defaults = {
      :children => @sample_children,
      :parameters => @sample_params,
      :template => @sample_template,
      :decorators => @sample_decorators
    }
  end

  it "should be correctly initialized from a defaults hash" do
    kind = 'SomeComponent'
    parent = 'Component'
    ancestors = [kind, parent]
    concrete_class = 'Component'
    
    definition = ComponentDefinition.new(kind, @sample_defaults, ancestors, concrete_class)

    definition.kind.should == kind
    definition.ancestors.should == ancestors
    definition.parent.should == parent
    definition.defaults.should == @sample_defaults
    definition.parameters.should == @sample_params
    definition.children.should == @sample_children
    definition.decorators.should == @sample_decorators
    definition.template.should == @sample_template
  end
  
  it "should merge defaults intelligently"
  
  it "should instantiate components with its defaults"
end
