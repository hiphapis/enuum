require 'active_record'
require_relative 'enuum/version'

module Enuum

  require_relative 'enuum/model'
  require_relative 'enuum/view'
  require_relative 'enuum/configuration'

  class << self
    attr_writer :configuration
    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  if defined?(ActiveRecord)
    ActiveRecord::Base.extend Enuum::Model
  end

  if defined?(ActionView)
    ActionView::Base.send :include, Enuum::View
  end
end
