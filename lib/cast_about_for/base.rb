module CastAboutFor

  extend ActiveSupport::Concern

  module ClassMethods
    def cast_about_for *args, &block
      options = args.extract_options!
      @params = options[:jsonapi] ? args[0][:filter] : args[0]

      @seach_model = self.all

      @options.each do |key, value|
        if key == :equal
          self.cast_about_for_by_equal(value)
        elsif key == :like
          self.cast_about_for_by_like(value)
        elsif key == :after
          self.cast_about_for_by_after(value)
        elsif key == :before
          self.cast_about_for_by_before(value)
        elsif key == :enum
          self.cast_about_for_by_enum(value)
        end
      end

      @seach_model = yield(@seach_model) if block_given?

      return @seach_model
    end

    def cast_about_for_by_equal search_values
      search_values.each do |search_value|
        @seach_model = @seach_model.where("#{search_value} = ?", @params[search_value.to_sym]) if @params.present? && @params.has_key?(search_value.to_sym)
      end
    end

    def cast_about_for_by_like search_values
      search_values.each do |search_value|
        @seach_model = @seach_model.where("#{search_value} LIKE ?", "%#{@params[search_value.to_sym]}%") if @params.present? && @params.has_key?(search_value.to_sym)
      end
    end

    def cast_about_for_by_after search_values
      search_values.each do |key, value|
        @seach_model = @seach_model.after(@params[value.to_sym].to_datetime, field: key) if @params.present? && @params.has_key?(value.to_sym)
      end
    end

    def cast_about_for_by_before search_values
      search_values.each do |key, value|
        @seach_model = @seach_model.before(@params[value.to_sym].to_datetime, field: key) if @params.present? && @params.has_key?(value.to_sym)
      end
    end

    def cast_about_for_by_enum search_values
      search_values.each do |search_value|
        @seach_model = @seach_model.where("#{search_value} = ?", self.send(search_value.pluralize.to_sym)[@params[search_value.to_sym]]) if @params.present? && @params.has_key?(search_value.to_sym)
      end
    end
  end
end
