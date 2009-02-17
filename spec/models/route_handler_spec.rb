require File.dirname(__FILE__) + '/../spec_helper'

describe RouteHandler do
  
  it "should be created" do
    lambda do
      RouteHandler.create!(:url => ':frequency/:name/:sign/:date', :transformation_rules => "")
    end.should change(RouteHandler, :count).by(1)
  end
  
  it "should be validated by presence" do
    route_handler = RouteHandler.new
    route_handler.should_not be_valid
    route_handler.errors.on(:url).should_not be_nil
  end
  
  it "should match path" do
    handler = RouteHandler.create!(:url => '(\w+)\/(\w+)\/(\w+)')
    RouteHandler.match('daily/overview/today').should == handler
    RouteHandler.match(%w{some some some}).should == handler
    RouteHandler.match('fengshui/love').should be_nil
  end
  
end