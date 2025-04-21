# frozen_string_literal: true

class ToolGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :skip_test, type: :boolean, default: false

  def create_tool_file
    template "tool.rb.tt", File.join("app/tools", "#{file_name}_tool.rb")
  end

  def create_test_file
    return if options[:skip_test]

    template "tool_spec.rb.tt", File.join("spec/tools", "#{file_name}_tool_spec.rb")
  end
end 
