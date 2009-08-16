module RouteHandlerTags
  include Radiant::Taggable

  desc %{
   Shows some value from route handler parameters. It has only one attribute - @name@, 
   that contains name of parameter.
   
   *Usage:*
   
   <pre><code><r:route_param name="parameter_name" /></code></pre>
  }
  tag 'route_param' do |tag|
    params = tag.locals.page.route_handler_params
    params && params[tag.attr['name'].to_sym]
  end


  desc %{
    Execute block if route handler parameter equal to specified value. It has attributes
    @name@ and @value@, where @name@ contains name of parameter and @value@ contains
    value that should be equal to.

    *Usage:*

    <pre><code><r:if_route_param_equals name="param_name" value="value"> some code </r:if_route_param_equals></code></pre>
  }
  tag 'if_route_param_equals' do |tag|
    params = tag.locals.page.route_handler_params
    show_block = params[tag.attr['name'].to_sym] == tag.attr['value']
    tag.expand if show_block
  end


  desc %{
    Execute block if route handler parameter *not* equal to specified value. It has attributes
    @name@ and @value@, where @name@ contains name of parameter and @value@ contains
    value that should be equal to.

    *Usage:*

    <pre><code><r:unless_route_param_equals name="param_name" value="value"> some code </r:unless_route_param_equals></code></pre>
  }
  tag 'unless_route_param_equals' do |tag|
    params = tag.locals.page.route_handler_params
    show_block = params[tag.attr['name'].to_sym] != tag.attr['value']
    tag.expand if show_block 
  end
  
end
