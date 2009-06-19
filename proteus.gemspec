################################################################################
# proteus.gemspec
#
# Defines the gem package used to distribute Proteus.
# -----------------------------------------------------------------------------
# (C) Copyright 2009 William Madden
# 
# This file is part of Proteus.
# 
# Proteus is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Proteus is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# Proteus.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

require 'rake'

spec = Gem::Specification.new

#-----------------------------
#  Package information
#-----------------------------

spec.name = 'proteus'

spec.version = '0.9.0'

spec.executables << 'pro'

spec.has_rdoc = true

spec.rdoc_options << '--title' << 'Proteus' <<
                       '--line-numbers'

spec.rubyforge_project = 'proteus'

spec.homepage = 'http://proteus.rubyforge.org'

spec.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a

spec.test_files = Dir.glob('test/spec/*_spec.rb')

spec.summary = 'Tool for generating structured text documents from abstract markup.'

spec.description = <<-EOF
  Proteus is an abstraction of general document definition and display markup
  that allows you to create and reuse complex patterns of structured content.
EOF


#-----------------------------
#  Author information
#-----------------------------

spec.author = 'William Madden'

spec.email = 'w.a.madden@gmail.com'


