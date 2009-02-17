require 'application'

class RouteHandlerExtension < Radiant::Extension
  version "0.1"
  description "If static page with given URL doesn't exist, it will try to open " +
              "some special page and send some special params to there."
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :route_handlers
    end
    map.connect '/q/*path', :controller => 'route_handler', :action => 'index'
  end
  
  def activate
    admin.tabs.add "Route Handlers", "/admin/route_handlers", :after => "Layouts" 
  end
  
  def deactivate
  end
  
end