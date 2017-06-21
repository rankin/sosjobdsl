#require "sosjobdsl/version"
require "nokogiri"

module Sosjobdsl
  require 'sosjobdsl/generic_dsl'

  autoload :Job,        'sosjobdsl/job'
  autoload :Order,      'sosjobdsl/order'
  autoload :Schedule,   'sosjobdsl/schedule'
  autoload :Params,     'sosjobdsl/params'
end
