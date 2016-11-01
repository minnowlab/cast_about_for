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
            validate_join_associations(record, association_name)

            association_operations.each do |operations|
              operations.each_value do |columns|
                association_name = association_name.is_a?(Hash) ? association_name.flatten.last : association_name
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

      def validate_join_associations(record, association_name)
        if association_name.is_a?(Hash)     #检查是否为嵌入式的joins，例如: A.joins(b: :c)
          association_name.each do |key, value|
            validate_join_association(record, key)
            validate_join_association(Object.const_get("#{key}".camelize.singularize), value)
          end
        else
          validate_join_association(record, association_name)
        end
      end

      def validate_join_association(record, association_name)
        # _reflections method come from rails ActiveRecord::Reflection
        raise ArgumentError, "Unknown association #{association_name} fo #{record}" unless record._reflections.keys.include?(association_name.to_s)
      end
    end
  end
end