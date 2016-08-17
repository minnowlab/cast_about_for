module CastAboutFor

  extend ActiveSupport::Concern

  module ClassMethods
    def cast_about_for *args, &block
      options = args.dup
      options = options.extract_options!

      jsonapi = options[:jsonapi] || false
      params = jsonapi ? args[0][:filter] : args[0]
      
      seach_model = self.all
      @options.each do |key, value|
        seach_model = send("cast_about_for_by_#{key}", value, params, seach_model)
      end

      seach_model = yield(seach_model) if block_given?

      return seach_model
    end

    def cast_about_for_by_equal search_values, params, seach_model
      search_values.each do |search_value|
        seach_model = seach_model.where("#{search_value} = ?", params[search_value.to_sym]) if params.present? && params.has_key?(search_value.to_sym)
      end
      seach_model
    end

    def cast_about_for_by_like search_values, params, seach_model
      search_values.each do |search_value|
        seach_model = seach_model.where("#{search_value} LIKE ?", "%#{params[search_value.to_sym]}%") if params.present? && params.has_key?(search_value.to_sym)
      end
      seach_model
    end

    def cast_about_for_by_after search_values, params, seach_model
      search_values.each do |key, value|
        seach_model = seach_model.after(params[value.to_sym].to_datetime, field: "#{self.to_s.tableize}.#{key}") if params.present? && params.has_key?(value.to_sym)
      end
      seach_model
    end

    def cast_about_for_by_before search_values, params, seach_model
      search_values.each do |key, value|
        seach_model = seach_model.before(params[value.to_sym].to_datetime, field: "#{self.to_s.tableize}.#{key}") if params.present? && params.has_key?(value.to_sym)
      end
      seach_model
    end

    def cast_about_for_by_enum search_values, params, seach_model
      search_values.each do |search_value|
        seach_model = seach_model.where("#{search_value} = ?", self.send(search_value.pluralize.to_sym)[params[search_value.to_sym]]) if params.present? && params.has_key?(search_value.to_sym)
      end
      seach_model
    end
  end
end
