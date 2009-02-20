require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::RouteHandlersController do
  integrate_views
  before do
    create_page_route_handler_and_user
    login_as @user
  end
  
  
  it "should get index" do
    get :index
    response.should be_success
    response.body.should include("Create Route Handler")
    response.body.should include("Destroy")
    response.body.should include("my_url")
    response.body.should include("my_description")
  end
  
  it "should get edit" do
    get :edit, :id => @route_handler.id
    response.should be_success
    response.should have_tag("input[value=my_url]")
  end
  
  it "should get new" do
    get :new
    response.should be_success
  end
  
  it "should get remove" do
    get :remove, :id => @route_handler.id
    response.should be_success
    response.should have_tag("form[action=#{admin_route_handler_path(@route_handler.id)}]")
  end
  
  it "should create item" do
    lambda do
      post :create, :route_handler => { 
        :url => "my_url2", :description => "desc2", :fields => "myfields", :page_id => @page.id
      }
      response.should redirect_to(admin_route_handlers_path)
    end.should change(RouteHandler, :count).by(1)
  end
  
  it "should update item" do
    put :update, :id => @route_handler.id, :route_handler => { :url => "my_url2", :page_id => @page.id }
    response.should redirect_to(admin_route_handlers_path)
    @route_handler.reload.url.should == "my_url2"
  end
  
  it "should remove item" do
    lambda do
      delete :destroy, :id => @route_handler.id
      response.should redirect_to(admin_route_handlers_path)
    end.should change(RouteHandler, :count).by(-1)
  end
end