require 'cast_about_for/base'
require 'active_record'
require 'active_support'
require 'by_star'

class ActiveRecord::Base
  def self.cast_about_for_params *args
    include CastAboutFor

    @options = args.extract_options!
  end
end
