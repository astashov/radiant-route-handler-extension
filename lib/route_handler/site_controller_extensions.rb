module RouteHandler::SiteControllerExtensions
  def self.included(base)
    base.class_eval do

      private
      
        def find_page_with_route_handler(*args)
          page = find_page_without_route_handler(*args)
          if !page || page.is_a?(FileNotFoundPage)
            logger.info("\033[1;33mWe weren't be able to find static page, trying to find route handler\033[0m")
            @route_handler = RouteHandler.match(params[:url])
            if @route_handler
              page = @route_handler.page
              logger.info("\033[1;32mRoute Handler was found, use its page #{CGI::escape(page.title)}\033[0m")
            else
              logger.debug(
                "\033[1;31mRoute Handler wasn't found\nYour url: " +
                "#{params[:url].to_a.join("/")}\nAvailabled Route Handlers:\n" + 
                "#{RouteHandler.find(:all).map(&:url).join("\n")}\033[0m"
              )
            end
          end
          page
        end
        
        alias_method_chain :find_page, :route_handler

    end
  end
end