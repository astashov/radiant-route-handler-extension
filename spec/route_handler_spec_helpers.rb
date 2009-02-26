module RouteHandlerSpecHelpers
   
  def login_as(user)
    controller.stub!(:authenticate).and_return(true)
    controller.stub!(:logged_in?).and_return(true)
    controller.stub!(:current_user).and_return(user)
    @current_user = user
  end  
  
  def create_page_route_handler_and_user
    @page = Page.create!(
      :title => 'New Page',
      :slug => 'page',
      :breadcrumb => 'New Page',
      :status_id => '1'
    )
    @route_handler = RouteHandler.create!(
      :url => "my_url", 
      :description => "my_description",
      :fields => "my_fields",
      :page => @page
    )
    @user = User.create!(
      :name => "Administrator", 
      :login => "admin", 
      :password => "test1", 
      :password_confirmation => "test1"
    )
  end
  
  def derived_parameters
<<EOM
period:
  -
    if:
      frequency: daily
    value: day
  - if:
      frequency: _any_
    value: other
title:
  -
    value: ":name"
something: another
EOM
  end
  
end