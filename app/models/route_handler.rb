class RouteHandler < ActiveRecord::Base
  
  validates_presence_of :url
  
  def self.match(path_params)
    handlers = find(:all)
    path = path_params.is_a?(String) ? path_params : path_params.join("/") 
    handler = handlers.select {|h| path.match(h.url) }.first    
  end
  
end