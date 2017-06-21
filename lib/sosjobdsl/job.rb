module Sosjobdsl
  class Job
    attr_accessor :description,
                  :options,
                  :schedule,
                  :params

    def initialize(title, &block)

      self.options = {
        title: title,
        name: title.downcase.gsub(' ', '_')
      }

      self.description = ""

      DSL.evaluate(self, &block)
    end

    def build_xml(xml = Nokogiri::XML::Builder.new({ encoding: 'ISO-8859-1' }))
      this = self

      xml.job(this.options) do

        xml.description(this.description) unless this.description.empty?

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

      def description(desc)
        job.description = desc
      end

      def option(name, value)
        job.options[name] = value
      end

      def schedule(opts={}, &block)
        job.schedule = Schedule.new(opts, &block)
      end

      def params(&block)
        job.params = Params.new(&block)
      end

    end

  end
end
