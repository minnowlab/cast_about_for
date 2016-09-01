module CastAboutFor
  module Search
    def cast_about_for *args, &block
      cast_about_params = class_variable_get(:@@cast_about_for_params).dup
      options = args.dup
      options = options.extract_options!

      jsonapi = options[:jsonapi] || false
      params = jsonapi ? args[0][:filter] : args[0]
      
      seach_model = self.all
      cast_about_params.each do |key, value|
        seach_model = send("cast_about_for_by_#{key}", value, params, seach_model)
      end

      seach_model = yield(seach_model) if block_given?

      return seach_model
    end

    private

    def cast_about_for_by_equal search_values, params, seach_model
      search_values.each do |search_value|
        search_column, search_name = obtain_value(search_value)
        seach_model = seach_model.where("#{search_column} = ?", params[search_name.to_sym]) if params.present? && params[search_name.to_sym].present?
      end
      seach_model
    end

    def cast_about_for_by_like search_values, params, seach_model
      search_values.each do |search_value|
        search_column, search_name = obtain_value(search_value)
        seach_model = seach_model.where("#{search_column} LIKE ?", "%#{params[search_name.to_sym]}%") if params.present? && params[search_name.to_sym].present?
      end
      seach_model
    end

    def cast_about_for_by_after search_values, params, seach_model
      step = "after"
      if search_values.is_a?(Array)
        search_values.each do |search_value|
          seach_model = find_records_from_by_star(search_value, params, seach_model, step)
        end
      else
        seach_model = find_records_from_by_star(search_values, params, seach_model, step)
      end
      seach_model
    end

    def cast_about_for_by_before search_values, params, seach_model
      step = "before"
      if search_values.is_a?(Array)
        search_values.each do |search_value|          
          seach_model = find_records_from_by_star(search_value, params, seach_model, step)
        end
      else
        seach_model = find_records_from_by_star(search_values, params, seach_model, step)
      end
      seach_model
    end

    def cast_about_for_by_enum search_values, params, seach_model
      search_values.each do |search_value|
        search_column, search_name = obtain_value(search_value)
        seach_model = seach_model.where("#{search_column} = ?", self.send(search_column.to_s.pluralize.to_sym)[params[search_name.to_sym]]) if params.present? && params[search_name.to_sym].present?
      end
      seach_model
    end

    def obtain_value(value)
      case value
        when Hash then [value.first.first, value.first.last]
        else [value, value]
      end          
    end

    def find_records_from_by_star(search_value, params, seach_model, step)
      search_column, search_name = obtain_by_star_value(search_value, params)
      seach_model = seach_model.send("#{step}", params[search_name.to_sym].to_datetime, field: "#{self.to_s.tableize}.#{search_column.to_s}") if params.present? && params[search_name.to_sym].present?
      seach_model
    end

    def obtain_by_star_value(value, params)
      field = value[:field].present? ? params[value[:field].to_sym] : nil
      column = field.present? ? field : :created_at
      raise ArgumentError, "Unknown column: #{column}" unless self.respond_to?(column) || self.column_names.include?(column.to_s)
      [column.to_sym, value[:time]]
    end
  end
end
