class RouteHandler < ActiveRecord::Base
  include RouteHandlerParser
  
  validates_presence_of :url, :fields, :page_id
  validate :correct_yaml_in_derived_parameters
  
  belongs_to :page
  
  
  def self.match(path_params)
    handlers = find(:all)
    array_of_params = params_conversion(path_params)
    string_of_params = array_of_params.join("/")
    handler = handlers.select do |h| 
      string_of_params.match(h.url)
    end.first
    if handler
      # First match is full URL, we don't need it
      matched_params = string_of_params.match(handler.url)[1..-1]
      params = handler.get_path_params(matched_params)
      params.merge!(handler.get_derived_params(params))
      handler.set_another_page!(params)
      handler.page.route_handler_params = params
    end
    handler
  end
  
    
  def fields
    (self['fields'] || "").split(',').map(&:strip)
  end
  
  
  def get_path_params(params)
    hash_of_params = {}
    fields.each_with_index do |field, index|
      hash_of_params[field.to_sym] = params[index]
    end
    hash_of_params
  end


  def get_derived_params(given_params)
    params = parse(:yaml => self.derived_parameters.to_s, :input_params => given_params)
    params.merge!(derived_date_params(given_params[:date])) if given_params[:date]
    given_params.merge!(params)
  end
  
  
      
  def set_another_page!(params)
    if params[:page_name]
      page = Page.find_by_slug(params[:page_name])
      self.page = page if page
    end
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
    
    
    def derived_date_params(given_date)
      date = date_conversion(given_date)
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