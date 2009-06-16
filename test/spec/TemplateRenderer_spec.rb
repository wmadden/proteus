################################################################################
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

require File.expand_path( 'src/TemplateRenderer.rb' )

include Bob


describe TemplateRenderer do
  
  #-----------------------------------------------------------------------------
  #  
  #  Input Constants
  #  
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #  
  #  Set up, tear down
  #  
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------
  #  
  #  Tests
  #  
  #-----------------------------------------------------------------------------
  
  it "should render components by parsing the template property using ERB"
  
  it "should render component templates in the scope of the component instance"
  
  it "should render scalars by calling their to_s method"
  
  it "should render arrays by concatenating their rendered elements"
  
  it "should render hashes by rendering their values, then calling the hash's to_s method"
  
end
