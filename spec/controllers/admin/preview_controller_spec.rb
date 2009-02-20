require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::PreviewController do
  integrate_views
  before do
    create_page_route_handler_and_user
    @snippet = Snippet.create!(:name => "new_snippet", :content => "Content")
    @layout = Layout.create!(:name => "New", :content => "Content", :content_type => "text/text")
    login_as @user
  end
    
  if Object.const_defined?("PageVersioningExtension")
    it "should assign route_handler_params to page when preview page" do
      get :page, :id => @page.id, :route_handler_params => "q=e&a=f"
      response.should be_success
      assigns(:page).route_handler_params.should == { :q => "e", :a => "f"}
    end

    it "should assign route_handler_params to page when preview snippet" do
      get :snippet, :id => @snippet.id, :page_to_preview => @page.id, :route_handler_params => "q=e&a=f"
      response.should be_success
      assigns(:page).route_handler_params.should == { :q => "e", :a => "f"}
    end

    it "should assign route_handler_params to page when preview layout" do
      get :layout, :id => @layout.id, :page_to_preview => @page.id, :route_handler_params => "q=e&a=f"
      response.should be_success
      assigns(:page).route_handler_params.should == { :q => "e", :a => "f"}
    end
  end
  
end
