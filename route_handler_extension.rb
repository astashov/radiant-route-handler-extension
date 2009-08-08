require 'application_controller'

class RouteHandlerExtension < Radiant::Extension
  version "0.1"
  description "If static page with given URL doesn't exist, it will try to open " +
              "some special page and send some special params to there."
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :route_handlers
    end
  end
  
  def activate
    admin.tabs.add "Route Handlers", "/admin/route_handlers", :after => "Layouts" 
    # We will store extracted from path params here
    Page.class_eval { attr_accessor :route_handler_params }
    SiteController.send :include, RouteHandler::SiteControllerExtensions
    Page.send :include, RouteHandlerTags
    Radiant::Taggable.send :include, RouteHandler::RadiusExtension
    
    # Add integration with Page Versioning and Webservices extensions - preview of
    # Webservice with route_handler params.
    if Object.const_defined?("PageVersioningExtension") && PageVersioning.enable_versioning
      Admin::ResourceController.send :include, RouteHandler::ResourceControllerExtensions
      Admin::PreviewController.send :include, RouteHandler::PreviewControllerExtensions
      
      admin.page.edit.add :form_bottom, "admin/route_handlers/preview_event_handler"
      admin.snippet.edit.add :form_bottom, "admin/route_handlers/preview_event_handler"
      admin.layout.edit.add :form_bottom, "admin/route_handlers/preview_event_handler"
    end
  end
  
  def deactivate
  end
  
end
