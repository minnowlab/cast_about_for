module Validator
  class Base
    attr_reader :attributes

    def initialize(options)
      p "#{options}"
      @attributes = options
    end
  end
end