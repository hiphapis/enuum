module Enuum
  module Model
    def enuum(name, data, options={})
      keys = data.is_a?(Hash) ? data.keys.map(&:to_s) : data
      enum name => keys
      # TODO
      # Enuum.configuration.validation
      options[:validation] = true if options[:validation].nil?
      if options[:validation] == true
        validates name, presence: true, inclusion: { in: keys }
      end

      # TODO
      # define name by key if name.blank? or data.is_a? Array

      # TODO
      # if options[:default_value].present?

      define_methods(name, data)
    end

    def enuum_status(status=nil, options={})
      status ||= Enuum.configuration.status_map
      enuum(:status, status, options)
    end

    private

    def define_methods(name, data)
      define_singleton_method "#{name}_map" do
        data
      end

      define_singleton_method "#{name}_array" do |*args|
        _key = args.first.present? ? args.first.to_sym : :name
        data.map { |k, v| [v && v[_key] || k, k] }
      end

      define_singleton_method "#{name}_on" do |*args|
        values = if args.length == 1 && args[0].is_a?(Array)
          args[0].map { |arg| self.send(name.to_s.pluralize)[arg] }
        else
          args.map { |arg| self.send(name.to_s.pluralize)[arg] }
        end
        self.where(name => values)
      end

      if data.is_a? Hash
        properties = data.values.map(&:keys).flatten.compact.uniq
        properties.each do |property|
          define_method "#{name}_#{property}" do
            self.send("#{name}_map")[property.to_sym] if self.send(name).present?
          end

          define_singleton_method "#{name}_#{property}" do |key|
            data[key.to_sym][property]
          end
        end
      end

      define_method "#{name}_map" do
        self.class.send("#{name}_map")[self.send(name).to_sym] if self.send(name).present?
      end

      define_method "#{name}_label" do
        ActionController::Base.helpers.enum_label(self, name.to_sym)
      end
    end
  end
end
