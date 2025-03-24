# frozen_string_literal: true

# Based on https://github.com/github/view_component/blob/master/lib/rails/generators/component/component_generator.rb
class ViewComponentGenerator < Rails::Generators::NamedBase
  ROOT_PATH = Rails.root.join("app/frontend/components")
  TEMPLATE_EXT = ".erb"
  TEST_SUFFIX = "spec"
  TEST_ROOT_PATH = Rails.root.join("spec/frontend/components")
  TEST_SYSTEM_ROOT_PATH = Rails.root.join("spec/system/components")

  source_root File.expand_path("templates", __dir__)

  class_option :skip_test, type: :boolean, default: false
  class_option :skip_system_test, type: :boolean, default: false
  class_option :skip_preview, type: :boolean, default: false

  argument :attributes, type: :array, default: [], banner: "attribute"

  def create_component_file
    template "component.rb", File.join(ROOT_PATH.to_s, class_path, file_name, "component.rb")
  end

  def create_template_file
    template "component.html#{TEMPLATE_EXT}", File.join(ROOT_PATH.to_s, class_path, file_name, "component.html#{TEMPLATE_EXT}")
  end

  def create_test_file
    return if options[:skip_test]

    template "component_#{TEST_SUFFIX}.rb", File.join(TEST_ROOT_PATH.to_s, class_path, "#{file_name}_#{TEST_SUFFIX}.rb")
  end

  def create_system_test_file
    return if options[:skip_system_test]

    template "component_system_#{TEST_SUFFIX}.rb", File.join(TEST_SYSTEM_ROOT_PATH.to_s, class_path, "#{file_name}_#{TEST_SUFFIX}.rb")
  end

  def create_preview_file
    return if options[:skip_preview]

    template "preview.rb", File.join(ROOT_PATH.to_s, class_path, file_name, "preview.rb")
  end

  private

  def parent_class
    "ApplicationViewComponent"
  end

  def preview_parent_class
    "ApplicationViewComponentPreview"
  end

  def initialize_signature
    return if attributes.blank?

    attributes.map { |attr| "option :#{attr.name}" }.join("\\n  ")
  end
end
