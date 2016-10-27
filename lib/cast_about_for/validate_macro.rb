module CastAboutFor
  module ValidateMacro

    class << self

      def validate(record, options)
        options.each do |key, value|
          case key
          when :joins then validate_join(record, value)
          when :includes then validate_includes(record, value)
          else self.validate_others(record, value)
          end
        end
      end

      def validate_join(record, value)
        value.each do |association|
          association.each do |association_name, association_operations|
            # _reflections method come from rails ActiveRecord::Reflection
            raise ArgumentError, "Unknown association #{association_name} fo #{record}" unless record._reflections.keys.include?(association_name.to_s)

            association_operations.each do |operations|
              operations.each_value do |columns|
                klass = Object.const_get("#{association_name}".camelize.singularize)
                columns = columns.is_a?(Array) ? columns : [columns]
                columns.each do |column|
                  column = column.is_a?(Hash) ? column.first.first : column
                  raise ArgumentError, "Unknown column: #{column} for #{klass}" unless klass.column_names.include?("#{column}")
                end
              end
            end
          end
        end
      end

      def validate_includes(record, value)
        value = value.is_a?(Array) ? value : [value]
        value.each do |association|
          raise ArgumentError, "Unknown association #{association} fo #{record}" unless record._reflections.keys.include?(association.to_s)
        end
      end

      def validate_others(record, value)
        value.each do |attribute|
          attribute = attribute.is_a?(Hash) ? attribute.first.first : attribute
          raise ArgumentError, "Unknown column: #{attribute} fo #{record}" unless record.respond_to?(attribute) || record.column_names.include?(attribute.to_s)
        end
      end
    end
  end
end