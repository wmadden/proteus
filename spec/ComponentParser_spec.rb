require '../src/ComponentParser.rb'

include Bob

describe ComponentParser do
  # Using basic 'Component's, the CP should interpret:
  #   * a scalar as the first child
  #   * a list as the children
  #   * a hash as parameters
  
  @scalar = "flat scalar"
  @list = [@scalar, @scalar, @scalar]
  @hash = [:a => @scalar, :b => @scalar, :c => @scalar]
  @hash = [:a => @scalar, :b => @scalar, :c => @scalar, 'children' => @list]
  
  it "should take a scalar as the first child" do
    component = ComponentParser.parse('Component', @scalar)
    component.children.length.should == 1
    component.children[0].should == @scalar
    component.params.length.should == 0
  end
  
  it "should take a list as the children" do
    component = ComponentParser.parse('Component', @list)
    component.children.should == @list
    component.params.length.should == 0
  end
  
  it "should take a hash as the parameters" do
    component = ComponentParser.parse('Component', @hash)
    component.params.should == @hash
    component.children.length.should == 0
  end
  
  it "should take a hash with 'children' set as the parameters, and the value of 'children' as the children" do
    component = ComponentParser.parse('Component', @hash_children)
    component.children.should == @list
    component.params.should == @hash
  end
end
