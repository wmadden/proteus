################################################################################
# Control.rb
#
# A form control.
#
# 23/02/09
# William Madden
# w.a.madden@gmail.com
################################################################################

require "Component"

class Control < Component

  def template
    <<-END
      <div class="control">
        <div class="label>
          <label for="<%= @input_name %>"><%= @input_name %></label>
        </div>
        <div class="input">
          <input type="<%= @input_type %>" name="<%= @input_name %>" />
        </div>
      </div>
    END
  end

  def init( params )
    @input_name = ""
    @input_type = "text"
    @input_options = ""
    
    if( params.is_a? Hash )
      @input_name = params["name"] if params["name"]
      @input_type = params["type"] if params["type"]
      @input_options = params["options"] if params["options"]
      
    elsif( params.is_a?(Array) )
      @input_name = params[0] if params.length > 0
      @input_type = params[1] if params.length > 1
      @input_options = params[2] if params.length > 2
    
    elsif( params.is_a?(String) )
      @input_name = params
    end
  end
end
