################################################################################
# Component.rb
#
# Unit tests for Component.
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

require 'src/Component.rb'

include Bob

describe Component do
  before(:all) do
    @sample_children = ["child1", "child2", "child3"]
    @sample_params = {
      'param1' => 'param1val',
      'param2' => 'param2val',
      'param3' => 'param3val',
    }
  end
  
  it "should iterate through children using next_child()" do
    component = Component.new('Component', {}, @sample_children)
    component.next_child.should == 'child1'
    component.next_child.should == 'child2'
    component.next_child.should == 'child3'
    component.next_child.should == nil
  end
  
  it "should give nil for next_child if there are no children" do
    component = Component.new('Component', {}, [])
    component.next_child.should == nil
  end
  
  it "should give parameter values for missing methods where possible" do
    component = Component.new('Component', @sample_params)
    component.param1.should == 'param1val'
    component.param2.should == 'param2val'
    component.param3.should == 'param3val'
  end
end
