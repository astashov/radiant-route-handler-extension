require File.dirname(__FILE__) + '/../spec_helper'

describe RouteHandlerTags do
  
  before do
    @page = Page.create!(
      :title => 'New Page',
      :slug => 'page',
      :breadcrumb => 'New Page',
      :status_id => '100'
    )
  end
  
  it "should show Route Handler Parameter by <r:route_param /> tag" do
    @page.route_handler_params = {:name => 'something'}
    @page.should render("<r:route_param name='name' />").as('something')
  end
  
  
  it "should substitute route handler params to any attribute of any tag" do
    @page.route_handler_params = {:name => 'something', :something => "else"}
    @page.should render("<r:route_param name='_:name:_' />").as('else')
  end

  
  it "should execute inner block if condition is true" do
    @page.route_handler_params = {:name => 'something'}
    @page.should render(
      "<r:if_route_param_equals name='name' value='bla'>Text</r:if_route_param_equals>"
    ).as('')
    @page.should render(
      "<r:if_route_param_equals name='name' value='something'>Text</r:if_route_param_equals>"
    ).as('Text')
  end

  it "should execute inner block unless condition is true" do
    @page.route_handler_params = {:name => 'something'}
    @page.should render(
      "<r:unless_route_param_equals name='name' value='bla'>Text</r:unless_route_param_equals>"
    ).as('Text')
    @page.should render(
      "<r:unless_route_param_equals name='name' value='something'>Text</r:unless_route_param_equals>"
    ).as('')
  end

  
end
