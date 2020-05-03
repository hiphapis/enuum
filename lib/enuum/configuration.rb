module Enuum
  class Configuration
    attr_accessor :status_map, :label_class
    def initialize
      @status_map = {
        running: { name: 'running', class: 'success' },
        pending: { name: 'pending', class: 'primary' },
      }
      @label_class = :class
      @validate = true
    end
  end
end
