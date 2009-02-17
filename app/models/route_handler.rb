class RouteHandler < ActiveRecord::Base
  
  validates_presence_of :url
  validates_presence_of :fields
  
  attr_accessor :path_params
  attr_reader :transformed_params
  
  
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
  
  
  def transform!
    @transformed_params ||= {}
    rules = YAML.load(self.transformation_rules)
    transform_date! if @path_params[:date]
    rules.each do |param, param_rules|
      param_rules.each do |rule|
        result = rule.delete('result')
        if should_use_current_rule?(rule)
          result = substitute_variables_in_result(result)
          @transformed_params[param.to_sym] = result
          break
        end
      end
    end
  end
  
  
  private
  
    def self.params_conversion(params)
      case 
      when params.is_a?(String); params.split('/')
      when params.is_a?(Array); params
      end
    end
    
    
    def transform_date!
      given_date = @path_params[:date]
      date = case
      when given_date == 'today'; Date.today
      when given_date == 'tomorrow'; Date.today + 1.day
      when given_date == 'yesterday'; Date.today - 1.day
      else; Date.civil(given_date[0..3].to_i, given_date[4..5].to_i, given_date[6..7].to_i)
      end
      @transformed_params[:date] = date.strftime("%m/%d/%Y")
    end
    
    
    def substitute_variables_in_result(result)
      result.gsub!(/:([a-zA-Z]+)/) do |s|
        @path_params[$1.to_sym]
      end
      result.gsub('-', '_')
    end
    
    
    def should_use_current_rule?(rule)
      condition = true
      rule.each do |key, value|
        if value == '_any_'
          condition &&= true
        else
          condition &&= @path_params[key.to_sym] == value
        end
      end
      condition
    end
  
end