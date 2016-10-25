require 'cast_about_for/search'
require 'cast_about_for/validate_macro'
module CastAboutFor
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      include Search
      CAST_ABOUT_FOR_KEY = [:equal, :like, :enum, :joins, :includes, :after, :before, :comparison]
      def cast_about_for_params *args

        options = args.extract_options!.dup

        options.each_key do |key|
          raise ArgumentError, "Unknown cast_about_for key: '#{key}" unless CAST_ABOUT_FOR_KEY.include?(key)
        end

        validate_keys = options.slice(*CAST_ABOUT_FOR_KEY.first(5))

        ValidateMacro.validate(self, validate_keys)

        class_variable_set(:@@cast_about_for_params, options)
      end
    end
  end
end