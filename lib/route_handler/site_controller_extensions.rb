module RouteHandler::SiteControllerExtensions
  def self.included(base)
    base.class_eval do

      private
      
        def find_page_with_route_handler(*args)
          page = find_page_without_route_handler(*args)
          unless page
            @route_handler = RouteHandler.match(params[:url])
            page = @route_handler.page if @route_handler
          end
          page
        end
        
        alias_method_chain :find_page, :route_handler

    end
  end
end