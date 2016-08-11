require 'cast_about_for/base'
require 'active_record'
require 'active_support'
require 'by_star'

class ActiveRecord::Base
  CASTABOUTFORKEY = [:equal, :like, :enum, :after, :before]
  CASTABOUTFORKEYNORMAL = [:equal, :like, :enum]
  CASTABOUTFORKEYBYSTAR = [:after, :before]
  def self.cast_about_for_params *args
    include CastAboutFor

    @options = args.extract_options!.dup

    @options.each_key do |key|
      raise ArgumentError, "Unknown cast_about_for key: '#{key}" unless CASTABOUTFORKEY.include?(key)
    end

    validate_keys = @options.slice(*CASTABOUTFORKEYNORMAL)
    validate_by_stars = @options.slice(*CASTABOUTFORKEYBYSTAR)

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
