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
  
end