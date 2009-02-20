require File.dirname(__FILE__) + "/../spec_helper"

describe SiteController do
  integrate_views
  before do
    Page.destroy_all
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
  
  it "should open page of route_handler" do
    get :show_page, :url => [ 'dailyoverview', 'today' ]
    response.should be_success
    response.body.should include('Hi there!')
    assigns(:route_handler).should == @route_handler
    assigns(:page).route_handler_params.should == { :name => 'dailyoverview', :date => 'today' }
  end
  
  it "should not show page if there are no matched pages and route handlers" do
    get :show_page, :url => [ 'daily', 'overview', 'today' ]
    response.headers['Status'].should == '404 Not Found'
    response.body.should include('Page Not Found')
  end

end