module RouteHandler::ResourceControllerExtensions
  def self.included(base)
    base.class_eval do      
      
      def set_preview_attributes_with_route_handler
        preview_attributes = set_preview_attributes_without_route_handler
        unless params[:route_handler_params].blank?
          preview_attributes[:route_handler_params] = params[:route_handler_params] 
        end
        preview_attributes
      end
      
      alias_method_chain :set_preview_attributes, :route_handler
      
    end
  end
end