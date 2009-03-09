################################################################################
# DocumentParser.rb
#
# Unit tests for DocumentParser.
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

require File.expand_path( 'src/DocumentParser.rb' )

include Bob

describe DocumentParser do
  before(:all) do
    # Set up paths
    @default_file_path = FileFinder.path
    FileFinder.path += ['spec/defs/DocumentParser']
    
    @sample_hash = {'an a' => 'A', 'a b' => 'B', 'a scalar' => 'junk'}
    @sample_list = ['A', 'B', 'c', 'd']
    @sample_component_scalar = 'A'
    @sample_flat_scalar = 'xyz'
  end

  it "should be able to parse hash with component values" do
    result = DocumentParser.parse(@sample_hash)
    result.length.should == 3
    result['an a'].kind.should == 'A'
    result['a b'].kind.should == 'B'
    result['a scalar'].should == 'junk'
    # Test parse_hash explicitly
    result = DocumentParser.parse_hash(@sample_hash)
    result.length.should == 3
    result['an a'].kind.should == 'A'
    result['a b'].kind.should == 'B'
    result['a scalar'].should == 'junk'
  end
  
  it "should be able to parse a list with component valus" do
    result = DocumentParser.parse(@sample_list)
    result.length.should == 4
    $stderr.puts result.inspect
    result[0].kind.should == 'A'
    result[1].kind.should == 'B'
    result[2].should == 'c'
    result[3].should == 'd'
    # Test parse_list explicitly
    result = DocumentParser.parse_list(@sample_list)
    result.length.should == 4
    $stderr.puts result.inspect
    result[0].kind.should == 'A'
    result[1].kind.should == 'B'
    result[2].should == 'c'
    result[3].should == 'd'
  end
  
  it "should be able to parse a scalar which is a component" do
    result = DocumentParser.parse(@sample_component_scalar)
    result.kind.should == 'A'
  end
  
  it "should be able to parse a scalar which is not a component" do
    result = DocumentParser.parse(@sample_flat_scalar)
    result.should == 'xyz'
  end
  
  it "should be able to load a file" do
    result = DocumentParser.load_file('spec/docs/test.yml')
    result.children.length.should == 6
    result.children[0].kind.should == 'A'
    result.children[1].kind.should == 'B'
    result.children[2].kind.should == 'C'
    result.children[3].should == 'XYZ'
    result.children[4].should == {'XYZ' => 'junk'}
    result.children[5].should == {'xyz' => 'junk'}
  end
  
  after(:all) do
    FileFinder.path = @default_file_path
  end
end
