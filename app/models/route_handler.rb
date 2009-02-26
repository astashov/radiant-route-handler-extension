class RouteHandler < ActiveRecord::Base
  include RouteHandlerParser
  
  validates_presence_of :url, :fields, :page_id
  validate :correct_yaml_in_derived_parameters
  
  cattr_accessor :path_params
  
  belongs_to :page
  
  
  def self.match(path_params)
    handlers = find(:all)
    converted_params = params_conversion(path_params)
    handler = handlers.select {|h| converted_params.join('/').match(h.url) }.first
    if handler
      handler.set_path_params!(converted_params) 
      handler.set_derived_params!
    end
    handler
  end
  
    
  def fields
    (self['fields'] || "").split(',').map(&:strip)
  end
  
  
  def set_path_params!(params)
    self.page.route_handler_params ||= {}
    fields.each_with_index do |field, index|
      self.page.route_handler_params[field.to_sym] = params[index]
    end
  end


  def set_derived_params!
    params = parse(:yaml => self.derived_parameters.to_s, :input_params => self.page.route_handler_params)
    self.page.route_handler_params.merge!(params)
  end
  
  
  private
  
    def self.params_conversion(params)
      case 
      when params.is_a?(String); params.split('/')
      when params.is_a?(Array); params
      end
    end
        
    
    # Validation rule. Check YAML in Rule Scheme (if it is not blank)
    def correct_yaml_in_derived_parameters
      error = false
      begin
        yaml = YAML.load(self.derived_parameters.to_s)
      rescue
        error = true
      end
      error = true if !yaml.blank? && yaml.is_a?(String)
      if error
        errors.add(:derived_parameters, "You should specify correct YAML format")
      end
    end
    
end