class RouteHandlerController < ApplicationController
  
  no_login_required
  
  def index
#    route_handler = RouteHandler.new(params[:path])
#    if params[:path].join("/").match(/(daily|weekly|monthly)\/(\w+)\/(\w+)\/(\w+)/)
#      render :text => "Success!"
#    else
#      redirect_to '/404.html'
#    end
  end
  
end