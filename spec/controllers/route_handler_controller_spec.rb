require File.dirname(__FILE__) + "/../spec_helper"

describe RouteHandlerController do
  integrate_views
  before do
    @page = Page.create!(
      :title => 'New Page',
      :slug => 'page',
      :breadcrumb => 'New Page',
      :status_id => '1',
      :parts => [{:name => "body", :content => "Hi there!"}],
      :status_id => 100 # Published
    )
    @route_handler = RouteHandler.create!(
      :url => '^(\w+)\/(\w+)$', 
      :description => "",
      :fields => "name, date",
      :page => @page
    )
  end
  
  it "should open specified page" do
    get :index, :path => [ 'dailyoverview', 'today' ]
    response.should be_success
    assigns(:route_handler).should == @route_handler
    response.body.should include('Hi there!')
  end
  
  it "should show 404 error if there are no matched route handlers" do
    get :index, :path => [ 'daily', 'overview', 'today' ]
    response.should redirect_to('/404.html')
    assigns(:route_handler).should be_nil
  end

end