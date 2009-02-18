class RouteHandler < ActiveRecord::Base
  
  validates_presence_of :url, :fields, :page_id
  
  attr_accessor :path_params
  attr_reader :transformed_params
  
  belongs_to :page
  
  
  def self.match(path_params)
    handlers = find(:all)
    converted_params = params_conversion(path_params)
    handler = handlers.select {|h| converted_params.join('/').match(h.url) }.first
    handler.set_path_params(converted_params) if handler
    handler
  end
  
    
  def fields
    (self['fields'] || "").split(',').map(&:strip)
  end
  
  
  def set_path_params(params)
    self.path_params = {}
    fields.each_with_index do |field, index|
      self.path_params[field.to_sym] = params[index]
    end
  end
  
  
  private
  
    def self.params_conversion(params)
      case 
      when params.is_a?(String); params.split('/')
      when params.is_a?(Array); params
      end
    end
    
  
end