#require "sosjobdsl/version"
require "nokogiri"

module Sosjobdsl
  require 'sosjobdsl/generic_dsl'

  autoload :Job,        'sosjobdsl/job'
  autoload :Schedule,   'sosjobdsl/schedule'
  autoload :Params,     'sosjobdsl/params'
end
