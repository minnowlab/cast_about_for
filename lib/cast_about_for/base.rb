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

        validate_keys = options.slice(*CAST_ABOUT_FOR_KEY.first(3))

        validate_keys.each do |key, value|
          value.each do |attribute|
            attribute = attribute.is_a?(Hash) ? attribute.first.first : attribute
            raise ArgumentError, "Unknown column: #{attribute}" unless self.respond_to?(attribute) || self.column_names.include?(attribute.to_s)
          end
        end

        class_variable_set(:@@cast_about_for_params, options)
      end
    end
  end
end