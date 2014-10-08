require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      controller_name = snake_case(self.class.to_s)
      content = File.read("views/#{controller_name}/#{template_name}.html.erb")
      render_content(ERB.new(content).result(binding), 'text/html')
    end

    def snake_case(string)
      result = ""

      string.each_char.with_index do |char, ind|
        result += char.downcase
        unless ind == string.length - 1
          if string[ind+1] == string[ind+1].upcase
            result += "_"
          end
        end
      end

      result
    end
  end
end
