################################################################################
# HTMLBuilder.rb
#
# Defines the static class HTMLBuilder, used to load Components from YAML
# source.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require "Component.rb"

class HTMLBuilder

  #
  # Parses text and returns the resultant components.
  #
  def parse(source)
    # TODO: write me
    return []
  end

  
  #
  # Parses and renders the given source.
  #
  def render(format, source)
    output = ""
    components = parse(source)
    
    for component in components
      output += component.render(format)
    end
  end
  
end
