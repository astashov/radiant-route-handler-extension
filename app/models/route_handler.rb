class RouteHandler < ActiveRecord::Base
  include RouteHandlerParser
  
  validates_presence_of :url, :fields, :page_id
  validate :correct_yaml_in_derived_parameters
  
  cattr_accessor :path_params
  
  belongs_to :page
  
  
  def self.match(path_params)
    handlers = find(:all)
    converted_params = params_conversion(path_params).join("/")
    handler = handlers.select do |h| 
      converted_params.match(h.url)
    end.first
    if handler
      # First match is full URL, we don't need it
      matched_params = converted_params.match(handler.url)[1..-1]
      handler.set_path_params!(matched_params) 
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
    params.merge!(derived_data_params) if self.page.route_handler_params[:date]
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
    
    
    def derived_data_params
      date = date_conversion(self.page.route_handler_params[:date])
      {
        :currentdate => date.strftime("%Y%m%d"),
        :currentyear => date.year.to_s,
        :currentmonth => date.strftime("%B"),
        :currentday => date.day.to_s,
        :tomorrow => (date + 1.day).strftime("%Y%m%d"),
        :yesterday => (date - 1.day).strftime("%Y%m%d"),
        :nextweek => (date + 1.week - ((date + 1.week).wday) + 1.day).strftime("%Y%m%d"),
        :lastweek => (date - 1.week - ((date - 1.week).wday) + 1.day).strftime("%Y%m%d"),
        :nextmonth => (date + 1.month - ((date + 1.month).day) + 1.day) .strftime("%Y%m%d"),
        :lastmonth => (date - 1.month - ((date - 1.month).day) + 1.day) .strftime("%Y%m%d"),
      }
    end
    
    def date_conversion(given_date)
      case
      when given_date == 'today'; Date.today
      when given_date == 'thismonth'; Date.civil(Date.today.year, Date.today.month, 1)
      when given_date == 'lastmonth'; Date.civil(Date.today.year, Date.today.month - 1, 1)
      when given_date == 'nextmonth'; Date.civil(Date.today.year, Date.today.month + 1, 1)
      when given_date == 'tomorrow'; Date.today + 1.day
      when given_date == 'yesterday'; Date.today - 1.day
      when given_date.match(/\d+_days_ago/); Date.today - given_date.match(/(\d+)_days_ago/)[1].to_i.days
      else; Date.strptime(given_date, '%Y%m%d') rescue Date.today
      end
    end
    
end