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

    validate_keys = @options.slice(*CAST_ABOUT_FOR_KEY.take(3))
    validate_by_stars = @options.slice(*CAST_ABOUT_FOR_KEY.last(2))

    validate_keys.each_value do |value|
      value.each do |k|
        raise ArgumentError, "Unknown column: #{k}" unless self.respond_to?(k) || self.column_names.include?(k.to_s)
      end
    end

    validate_by_stars.each_value do |value|
      value.keys.each do |k|
        raise ArgumentError, "Unknown column: #{k}" unless self.respond_to?(k) || self.column_names.include?(k.to_s)
      end
    end
  end
end
