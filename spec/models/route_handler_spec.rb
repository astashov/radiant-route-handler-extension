require File.dirname(__FILE__) + '/../spec_helper'

describe RouteHandler do
  
  before do
    @page = Page.create!(
      :title => 'New Page',
      :slug => 'page',
      :breadcrumb => 'New Page',
      :status_id => '1'
    )
  end
  
  it "should be created" do
    lambda do
      RouteHandler.create!(:url => "(\w+)\/(\w+)\/(\w+)", :fields => 'frequency,name,date', :page => @page)
    end.should change(RouteHandler, :count).by(1)
  end
  
  it "should be validated by presence" do
    route_handler = RouteHandler.new
    route_handler.should_not be_valid
    route_handler.errors.on(:url).should_not be_nil
    route_handler.errors.on(:fields).should_not be_nil
    route_handler.errors.on(:page_id).should_not be_nil
  end
  
  it "should correctly not transform invalid YAML" do
    route_handler = RouteHandler.new(:url => "web", :fields => "web", :derived_parameters => "as: as: 'sadf", :page => @page)
    route_handler.should_not be_valid
    route_handler.errors.on(:derived_parameters).should_not be_nil
  end
  
  it "should correctly not transform string" do
    route_handler = RouteHandler.new(:url => "web", :fields => "web", :derived_parameters => "sadf", :page => @page)
    route_handler.should_not be_valid
    route_handler.errors.on(:derived_parameters).should_not be_nil
  end
  
  it "should correctly not transform blank string" do
    route_handler = RouteHandler.create!(
      :url => '(\w+)\/(\w+)\/(\w+)', 
      :fields => 'frequency,name,date', 
      :page => @page,
      :derived_parameters => ''
    )
    route_handler.should be_valid
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.page.route_handler_params.should == {
      :frequency => 'daily',
      :name => 'overview', 
      :date => 'today'
    }
  end
  
  it "should match path" do
    handler = RouteHandler.create!(:url => '(\w+)\/(\w+)\/(\w+)', :fields => 'frequency,name,date', :page => @page)
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.should == handler
    matched_handler.page.route_handler_params.should == {
      :frequency => 'daily',
      :name => 'overview', 
      :date => 'today'
    }
    RouteHandler.match(%w{some some some}).should == handler
    RouteHandler.match('fengshui/love').should be_nil
  end  
  
  it "should set derived parameters" do
    handler = RouteHandler.create!(
      :url => '(\w+)\/(\w+)\/(\w+)', 
      :fields => 'frequency,name,date', 
      :page => @page,
      :derived_parameters => derived_parameters
    )
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.page.route_handler_params.should == {
      :frequency => 'daily',
      :name => 'overview', 
      :date => 'today',
      :period => 'day',
      :title => 'overview',
      :something => 'another'
    }
    
    matched_handler = RouteHandler.match('weekly/overview/today')
    matched_handler.page.route_handler_params.should == {
      :frequency => 'weekly',
      :name => 'overview', 
      :date => 'today',
      :period => 'other',
      :title => 'overview',
      :something => 'another'
    }
  end

end