module Sosjobdsl
  class Order
    attr_accessor :options,
                  :schedule,
                  :params

    def initialize(title, &block)
      self.options = {
        title: title
      }

      DSL.evaluate(self, &block)
    end

    def build_xml(xml = Nokogiri::XML::Builder.new({ encoding: 'ISO-8859-1' }))
      this = self

      xml.order(this.options) do
        this.params.build_xml(xml) if this.params

        this.schedule.build_xml(xml) if this.schedule
      end

      xml
    end

    def to_xml
      build_xml.to_xml
    end

    private

    class DSL < GenericDSL

      def schedule(opts={}, &block)
        order.schedule = Schedule.new(opts, &block)
      end

      def params(&block)
        order.params = Params.new(&block)
      end

    end

  end
end
