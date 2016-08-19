require 'cast_about_for/base'
require 'cast_about_for/search'
require 'active_record'
require 'active_support'
require 'by_star'

ActiveRecord::Base.send :include, CastAboutFor::Base
