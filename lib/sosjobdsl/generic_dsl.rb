module Sosjobdsl
  class GenericDSL
    attr_reader :delegate

    def self.evaluate(delegate, &block)
      self.new(delegate, &block)
    end

    def initialize(delegate, &block)
      @delegate = delegate

      instance_eval(&block)
    end

    def method_missing(m, *args)
      delegate.options[m] = args.shift.to_s
    end

    def self.inherited(subclass)
      delegate_name = subclass.to_s.split('::').pop(2)
                        .first.gsub(/([A-Z])/, '_\1').downcase.sub(/^_/, '')

      subclass.send(:alias_method, delegate_name.to_sym, :delegate)
    end
  end
end
