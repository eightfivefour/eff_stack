# Configure ViewComponent
Rails.application.config.view_component.view_component_path = "app/frontend/components"
Rails.application.config.view_component.preview_paths << Rails.root.join("app/frontend/components/previews") 

ActiveSupport.on_load(:view_component) do
  ViewComponent::Preview.extend ViewComponentContrib::Preview::Sidecarable
end