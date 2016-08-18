require 'cast_about_for/base'
require 'cast_about_for/search'
require 'active_record'
require 'active_support'
require 'by_star'
require 'cast_about_for/validator/base'
require 'cast_about_for/validator/equal_validator'
require 'cast_about_for/validator/like_validator'
require 'cast_about_for/validator/enum_validator'
require 'cast_about_for/validator/after_validator'
require 'cast_about_for/validator/before_validator'

ActiveRecord::Base.send :include, CastAboutFor::Base
