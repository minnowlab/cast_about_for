require 'cast_about_for/search'
module CastAboutFor
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      include Search
      CAST_ABOUT_FOR_KEY = [:equal, :like, :enum, :after, :before]
      def cast_about_for_params *args

        options = args.extract_options!.dup

        options.each_key do |key|
          raise ArgumentError, "Unknown cast_about_for key: '#{key}" unless CAST_ABOUT_FOR_KEY.include?(key)
        end

        validate_keys = options.slice(*CAST_ABOUT_FOR_KEY)

        validate_keys.each do |key, value|
          validator_name = "Validator::#{key.to_s.camelize}Validator"
          validator = validator_name.constantize
          a = validator.new(value)
          value = value.is_a?(Array) ? value : value.keys
          value.each do |k|
            raise ArgumentError, "Unknown column: #{k}" unless self.respond_to?(k) || self.column_names.include?(k.to_s)
          end
        end
        class_variable_set(:@@cast_about_for_params, options)
      end
    end
  end
end