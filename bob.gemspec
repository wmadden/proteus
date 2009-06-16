################################################################################
# bob.gemspec
#
# Defines the gem package used to distribute Bob.
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

require 'rake'

spec = Gem::Specification.new

#-----------------------------
#  Package information
#-----------------------------

spec.name = 'bob'

spec.version = '0.9.0'

spec.executables << 'bob'

spec.has_rdoc = true

spec.rdoc_options << '--title' << 'Bob' <<
                       '--line-numbers'

spec.rubyforge_project = 'bob'

spec.homepage = 'http://bob.rubyforge.org'

spec.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a

spec.test_files = Dir.glob('test/spec/*_spec.rb')

spec.summary = 'Tool for generating structured text documents from abstract markup.'

spec.description = <<-EOF
  Bob is an abstraction of general document definition and display markup
  whereby complex patterns of structured content can be created, mixed and
  reused.
EOF


#-----------------------------
#  Author information
#-----------------------------

spec.author = 'William Madden'

spec.email = 'w.a.madden@gmail.com'


