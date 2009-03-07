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

require 'src/ParserHelper.rb'
require 'src/Component.rb'

include Bob

# Important functions
#   * get_class
#   * is_scalar?
#   * is_component?
describe ParserHelper do
  it "should be able to get known classes"
  it "should be able to get classes on the path"
  it "should be able to test if something's a scalar"
  it "should be able to tell if something's a component"
end
