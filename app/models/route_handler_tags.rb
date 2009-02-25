module RouteHandlerTags
  include Radiant::Taggable

  tag 'route_param' do |tag|
    params = tag.locals.page.route_handler_params
    params && params[tag.attr['name'].to_sym]
  end
  
end