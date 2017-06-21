module Sosjobdsl
  class Schedule

    attr_accessor :options,
                  :days,
                  :weekdays,
                  :monthdays,
                  :holidays

    def initialize(opts={}, &block)

      self.options = opts

      self.days = {}

      self.weekdays = {}

      self.monthdays = {
        weekday: {},
        day: {}
      }

      self.holidays = {
        holiday: [],
        weekday: {}
      }

      DSL.evaluate(self, &block)
    end

    def build_xml(xml = Nokogiri::XML::Builder.new({ encoding: 'ISO-8859-1' }))
      this = self

      xml.run_time(this.options) do

        this.days.each do |(date, periods)|
          xml.date(date: date) do
            periods.each { |p| xml.period(p) }
          end
        end

        unless this.weekdays.keys.empty?
          xml.weekdays do
            this.weekdays.each do |(day, periods)|
              xml.day(day: day) do
                periods.each { |p| xml.period(p) }
              end
            end
          end
        end

        unless this.monthdays.values.any? { |v| v.keys.empty? }
          xml.monthdays do
            this.monthdays.each do |(type, values)|
              values.each do |(day, options)|
                args = { day: day }

                if options.is_a? Array
                  periods = options
                else
                  args[:which] = options[:which]
                  periods = options[:periods]
                end

                xml.send(type, args) do
                  periods.each { |p| xml.period(p) }
                end
              end
            end
          end
        end

        unless this.monthdays.values.any? { |v| v.keys.empty? }
          xml.holidays do
            this.holidays[:holiday].each do |date|
              xml.holiday(date: date)
            end

            unless this.holidays[:weekday].keys.empty?
              xml.weekdays do
                this.holidays[:weekday].each do |(day, options)|
                  xml.day({ day: day, which: options[:which] }) do
                    options[:periods].each { |p| xml.period(p) }
                  end
                end
              end
            end
          end
        end
      end

      xml
    end

    private

    class DSL < GenericDSL

      def day(x, *periods)
        schedule.days[x] = periods
      end

      def weekday(x, *periods)
        schedule.weekdays[x] = periods
      end

      def monthday(x, *periods)
        if x.to_i != 0
          schedule.monthdays[:day][x] = periods
        else
          schedule.monthdays[:weekday][x] = { which: periods.shift,
                                              periods: periods
                                            }
        end
      end

      def holiday(x, *periods)
        if x =~ /\d{4}-\d{2}-\d{2}/
          schedule.holidays[:holiday] << x
        else
          schedule.holidays[:weekday][x] = { which: periods.shift,
                                             periods: periods
                                           }
        end
      end
    end

  end
end
