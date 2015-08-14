#require "sosjobdsl/version"
require "nokogiri"

module Sosjobdsl

  class Job
    attr_accessor :descript, :lock_use, 
      :job,
      :settings, :options,
      :process, :schedule_opts,
      :days, :weekdays,
      :monthdays, :months,
      :holidays
    
    def initialize(title, &block)

      self.job = {}

      self.descript = ""
      
      self.settings = {}
      
      self.options = {}

      self.days = []

      self.monthdays = {
        :weekdays => [],
        :days => ""
      }

      self.months = []

      self.holidays = []

      self.job[:title] = title

      self.job[:name] = title
        .downcase.gsub(
          ' ', '_'
        ).to_sym 

      instance_eval &block      
    end

    def description(desc)
      self.descript= desc
    end

    def setting(name, value)
      self.settings[name]= value
    end

    def option(name, value)
      self.options[name]= value
    end

    def execute(*conf)
      self.process = conf.shift
    end

    def schedule(opts, &block)
      self.schedule_opts= opts
      instance_eval &block
    end

    def day(x)
      self.days.push(x)
    end

    def weekday(x)
      self.weekdays = x
    end

    def monthday(*x)
      if x.length == 1 && x.first.instance_of?(String)
        self.monthdays[:days] = x.shift
      else
        self.monthdays[:weekdays].push({:day => "#{x.first.tr('^0-9', '')}", :which => x.last})
      end
    end

    def holiday(x)
      self.holidays.push(x)
    end

    def method_missing(m, *args)
      self.job[m] = args.shift.to_s
    end

    def to_xml
      e = {:encoding => 'ISO-8859-1'}
      builder= 
      Nokogiri::XML::Builder              
      .new(e) do |xml|
        xml.job(self.job) {       
          d= self.descript
          unless d.empty?
            xml.description d 
          end

          xml.settings {
            self.settings.each do |k,v|
              setting = k 
              xml.send(setting) {
               xml.cdata v 
              }
            end
          }

          if self.process
            xml.process(self.process) {
              xml.environment
            }
          end

          if self.schedule_opts.nil?
            xml.run_time({
              :once => "yes", 
              :begin => "00:00", 
              :end => "00:00"
            })
          else
            xml.run_time(
              self.schedule_opts) {
              unless self.days.empty?
                self.days.each do |d|
                  xml.date({
                    :date => d
                  })         
                end
              end
              
              unless self.weekdays.nil?
                xml.weekdays {
                  xml.day({
                    :day => self.weekdays
                  })
                }
              end

              unless self.monthdays[
                :weekdays
              ].empty? && self.monthdays[
                :days
              ].empty? 
                xml.monthdays {
                  unless self.monthdays[
                    :days
                  ].empty?
                    xml.day({
                      :day => self
                      .monthdays[
                        :days]
                    })
                  end

                  unless self.monthdays[:weekdays].empty?
                    self.monthdays[:weekdays].each do |wd|
                      xml.weekday({
                        :which => wd[:which].downcase,
                        :day => wd[:day]
                      }) 
                    end
                  end
                }
              end

              unless self.holidays.empty?
                xml.holidays {
                  self.holidays.each do |h|
                    xml.holiday({:date => h}) 
                  end
                }
              end

             # months
             # holidays 
            }
          end

        }
      end  

      puts builder.to_xml
    end

    private

  end

end
