module PageVersioning; @enable_versioning = true; end
require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::PagesController do
  integrate_views
  before do
    create_page_route_handler_and_user
    login_as @user
  end
  if Object.const_defined?("PageVersioningExtension")
    it "should redirect to preview page with route_handler_params" do
      put :update, :page => {:title => "title"}, :id => @page.id, 
        :route_handler_params => "lala=fafa", :preview => "Save and Preview"
      response.should redirect_to(
        :controller => 'admin/preview', :action => 'page', :id => @page.id, 
        :route_handler_params => "lala=fafa"
      )
    end
  end
end

describe Admin::SnippetsController do
  integrate_views
  before do
    create_page_route_handler_and_user
    @snippet = Snippet.create!(:name => "new_snippet", :content => "Content")
    login_as @user
  end
  if Object.const_defined?("PageVersioningExtension")
    it "should redirect to preview snippet with route_handler_params" do
      put :update, :snippet => {:name => "title"}, :id => @snippet.id, :page_to_preview => @page.id,
        :route_handler_params => "lala=fafa", :preview => "Save and Preview"
      response.should redirect_to(
        :controller => 'admin/preview', :action => 'snippet', :id => @snippet.id, 
        :route_handler_params => "lala=fafa", :page_to_preview => @page.id
      )
    end
  end
end

describe Admin::LayoutsController do
  integrate_views
  before do
    create_page_route_handler_and_user
    @layout = Layout.create!(:name => "New", :content => "Content", :content_type => "text/text")
    login_as @user
  end
  if Object.const_defined?("PageVersioningExtension")
    it "should redirect to preview layout with route_handler_params" do
      put :update, :layout => {:name => "title"}, :id => @layout.id, :page_to_preview => @page.id,
        :route_handler_params => "lala=fafa", :preview => "Save and Preview"
      response.should redirect_to(
        :controller => 'admin/preview', :action => 'layout', :id => @layout.id, 
        :route_handler_params => "lala=fafa", :page_to_preview => @page.id
      )
    end
  end
end