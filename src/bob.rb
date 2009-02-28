#!/usr/bin/ruby
################################################################################
# bob.rb
# 
# The executable version of Bob. Takes as its arguments the files to parse,
# otherwise reads from standard input.
#
# Outputs the rendered XHTML.
#
# 26/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require File.join(File.dirname(__FILE__), 'lib/Bob.rb')

# Specify library directory here
libdir = '/usr/lib/bob/rails:/usr/lib/bob'

envpath = ENV['BOB_PATH']
if envpath and Bob::path
  envpath += ":"
end

Bob::path = "#{envpath.to_s}#{Bob::path}:#{libdir}"

$stderr.print "Using path #{Bob::path}\n"

if ARGV.length == 0
  puts Bob.parse( YAML::load($stdin) )
else
  for arg in ARGV do
    components = Bob::parse( YAML::load_file(arg) )
  
    puts components
  end
end
