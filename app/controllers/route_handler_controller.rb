class RouteHandlerController < SiteController
  
  no_login_required
  
  
  def index
    @route_handler = RouteHandler.match(params[:path])
    if @route_handler
      show_page
    else
      redirect_to '/404.html'
    end
  end
  
  
  private
  
    def find_page(*args)
      found = @route_handler.page
      found if found and (found.published? or dev?)
    end
  
end