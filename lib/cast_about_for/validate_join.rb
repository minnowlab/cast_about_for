module CastAboutFor
  module ValidateJoin
    def self.validate_joins(record, value)
      value.each do |association|
        association.each do |association_name, association_operations|
          # _reflections method come from rails ActiveRecord::Reflection
          raise ArgumentError, "Unknown association #{association_name} fo #{record}" unless record._reflections.keys.include?(association_name.to_s)

          association_operations.each do |operations|
            operations.each_value do |columns|
              klass = Object.const_get("#{association_name}".capitalize.singularize)
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
  end
end