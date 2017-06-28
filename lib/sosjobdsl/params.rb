module Sosjobdsl
  class Params

    attr_accessor :params,
                  :copy_params

    def initialize(&block)
      self.params = []
      self.copy_params = []

      DSL.evaluate(self, &block) if block_given?
    end

    def build_xml(xml = Nokogiri::XML::Builder.new({ encoding: 'ISO-8859-1' }))
      this = self

      xml.params do
        this.params.each do |param|
          xml.param(param)
        end

        this.copy_params.each do |from|
          xml.copy_params(from: from)
        end
      end

      xml
    end

    def to_xml
      build_xml.to_xml
    end

    private

    class DSL < GenericDSL

      def copy_params_from(p)
        params.copy_params << p
      end

      def param(name, value)
        params.params << { name: name, value: value }
      end
    end
  end
end
