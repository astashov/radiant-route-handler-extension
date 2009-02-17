require File.dirname(__FILE__) + '/../spec_helper'

describe RouteHandler do
  
  it "should be created" do
    lambda do
      RouteHandler.create!(:url => "(\w+)\/(\w+)\/(\w+)", :fields => 'frequency,name,date')
    end.should change(RouteHandler, :count).by(1)
  end
  
  it "should be validated by presence" do
    route_handler = RouteHandler.new
    route_handler.should_not be_valid
    route_handler.errors.on(:url).should_not be_nil
    route_handler.errors.on(:fields).should_not be_nil
  end
  
  it "should match path" do
    handler = RouteHandler.create!(:url => '(\w+)\/(\w+)\/(\w+)', :fields => 'frequency,name,date')
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.should == handler
    matched_handler.path_params.should == {
      :frequency => 'daily',
      :name => 'overview', 
      :date => 'today'
    }
    RouteHandler.match(%w{some some some}).should == handler
    RouteHandler.match('fengshui/love').should be_nil
  end
  
  it "should correctly transform special parameters" do
    RouteHandler.create!(
      :url => '([a-zA-Z\-_]+)\/([a-zA-Z\-_]+)\/([a-zA-Z\-_]+)\/([a-zA-Z\-_]+)', 
      :fields => 'frequency,name,sign,date', 
      :transformation_rules => rules
    )
    handler = RouteHandler.match('daily/cosmic-calendar/aries/today')
    handler.transform!
    handler.transformed_params.should == { 
      :content_type => 'cosmic_calendar',
      :sign => 'aries',
      :date => (Date.today).strftime("%m/%d/%Y")
    }
  end
  
  it "should correctly transform usual parameters" do
    RouteHandler.create!(
      :url => '(\w+)\/(\w+)\/(\w+)\/(\w+)', 
      :fields => 'frequency,name,sign,date', 
      :transformation_rules => rules
    )
    handler = RouteHandler.match('daily/overview/taurus/yesterday')
    handler.transform!
    handler.transformed_params.should == { 
      :content_type => 'daily_overview',
      :sign => 'taurus',
      :date => (Date.today - 1.day).strftime("%m/%d/%Y")
    }
  end
  

end