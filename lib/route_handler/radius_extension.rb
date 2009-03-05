module RouteHandler::RadiusExtension
    
  def self.included(base)
    base.module_eval do
  
      def render_tag_with_route_handler(name, tag_binding)
        tag_binding.attr.dup.each do |key, value|
          if match = value.match(/_:(.*):_/)
            tag_binding.attr[key].gsub!(/_:.*?:_/, tag_binding.locals.page.route_handler_params[match[1].to_sym])
          end
        end
        render_tag_without_route_handler(name, tag_binding)
      end

      alias_method_chain :render_tag, :route_handler
      
    end
  end
  
end