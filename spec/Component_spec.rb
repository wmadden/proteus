require '../src/Component.rb'

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
  
  it "should recognize component names" do
    Component::NameRegexp.should =~ 'Component'
    Component::NameRegexp.should =~ 'CamelcaseComponent'
    Component::NameRegexp.should_not =~ 'notcomponent'
    Component::NameRegexp.should_not =~ 'Not A Component'
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
