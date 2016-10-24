require 'cast_about_for/search'
require 'cast_about_for/validate_join'
module CastAboutFor
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      include Search
      CAST_ABOUT_FOR_KEY = [:equal, :like, :enum, :joins, :after, :before, :comparison]
      def cast_about_for_params *args

        options = args.extract_options!.dup

        options.each_key do |key|
          raise ArgumentError, "Unknown cast_about_for key: '#{key}" unless CAST_ABOUT_FOR_KEY.include?(key)
        end

        validate_keys = options.slice(*CAST_ABOUT_FOR_KEY.first(4))

        validate_keys.each do |key, value|
          unless key != :joins
            ValidateJoin.validate_joins(self, value)
            next
          end
          value.each do |attribute|
            attribute = attribute.is_a?(Hash) ? attribute.first.first : attribute
            raise ArgumentError, "Unknown column: #{attribute} fo #{self}" unless self.respond_to?(attribute) || self.column_names.include?(attribute.to_s)
          end
        end

        class_variable_set(:@@cast_about_for_params, options)
      end

      private
      # def validate_joins(value)
      #   value.each do |association|
      #     association.each do |association_name, association_operations|
      #       # _reflections method come from rails ActiveRecord::Reflection
      #       raise ArgumentError, "Unknown association #{association_name} fo #{self}" unless self._reflections.keys.include?(association_name.to_s)
      #     end
      #   end
      # end
      # def validate_joins(value)
      #   value.each do |association|
      #     association.each do |association_name, association_operations|
      #       # _reflections method come from rails ActiveRecord::Reflection
      #       raise ArgumentError, "Unknown association #{association_name} fo #{self}" unless self._reflections.keys.include?(association_name.to_s)

      #       association_operations.each do |operations|
      #         operations.each_value do |column|
      #           klass = Object.const_get("#{association_name}".capitalize.singularize)
      #           column = column.is_a?(Hash) ? column.first.first : column
      #           raise ArgumentError, "Unknown column: #{column} for #{klass}" unless klass.column_names.include?("#{column}")
      #         end
      #       end
      #     end
      #   end
      # end
    end
  end
end