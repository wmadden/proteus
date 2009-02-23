################################################################################
# Form.rb
#
# A form component, used to render typical HTML forms.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require "Component"

class Form < Component

  attr_reader :controls

  def template
    <<-END
      <div class="form">
        <%= render_children() %>
      </div>
    END
  end

  def init( params )
    @controls = []
    
    if( params.is_a? Hash )
      # Ignore everything but controls for now
      params.each do |control, type|
        if( type == "Control" )
          @controls.push(control)
        end
      end
    elsif( params.is_a?(Array) )
      params.each do |control|
        if( control.is_a?(Component) and control.is_kind?("Control") )
          @controls.push(control)
        end
      end
    end
  end

  def render_children
    result = ""
    
    @controls.each do |control|
      result += control.render(:xhtml)
    end
    
    return result
  end
  
end
