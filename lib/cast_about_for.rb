require 'cast_about_for/base'
require 'active_record'
require 'active_support'
require 'by_star'

class ActiveRecord::Base
  CAST_ABOUT_FOR_KEY = [:equal, :like, :enum, :after, :before]
  def self.cast_about_for_params *args
    include CastAboutFor

    @options = args.extract_options!.dup

    @options.each_key do |key|
      raise ArgumentError, "Unknown cast_about_for key: '#{key}" unless CAST_ABOUT_FOR_KEY.include?(key)
    end

    validate_keys = @options.slice(*CAST_ABOUT_FOR_KEY)

    validate_keys.each_value do |value|
      value = value.is_a?(Array) ? value : value.keys
      value.each do |k|
        raise ArgumentError, "Unknown column: #{k}" unless self.respond_to?(k) || self.column_names.include?(k.to_s)
      end
    end
  end
end
