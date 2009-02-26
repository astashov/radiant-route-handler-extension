module RouteHandlerTags
  include Radiant::Taggable

  desc %{
   Shows some value from route handler parameters. It has only one attribute - @name@, 
   that contains name of value.
   
   *Usage:*
   
   <pre><code><r:route_param name="value_name" /></code></pre>
  }
  tag 'route_param' do |tag|
    params = tag.locals.page.route_handler_params
    params && params[tag.attr['name'].to_sym]
  end
  
end