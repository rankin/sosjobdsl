# Sosjobdsl

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sosjobdsl`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sosjobdsl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sosjobdsl

## Usage

    require 'sosjobdsl'

    x = Sosjobdsl::Job.new("My Test Job") do
      description "My job is so great!"
      enabled "yes"

      params do
        param "foo", "bar"
      end

      schedule do
        day "2015-08-13"
        day "2015-12-24"
        weekday "1", single_start: '08:00'
        monthday "4"
        monthday "3rd", "Monday", begin: '08:00', end: '12:30'
        holiday "2015-12-25"
        holiday "2015-12-24"
      end
    end

    x.to_xml

produces

    <?xml version="1.0" encoding="ISO-8859-1"?>
    <job title="My Test Job" name="my_test_job" enabled="yes">
      <description>My job is so great!</description>
      <params>
        <param name="foo" value="bar"/>
      </params>
      <run_time>
        <date date="2015-08-13"/>
        <date date="2015-12-24"/>
        <weekdays>
          <day day="1">
            <period single_start="08:00"/>
          </day>
        </weekdays>
        <monthdays>
          <weekday day="monday" which="3">
            <period begin="08:00" end="12:30"/>
          </weekday>
          <day day="4"/>
        </monthdays>
        <holidays>
          <holiday date="2015-12-25"/>
          <holiday date="2015-12-24"/>
        </holidays>
      </run_time>
    </job>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sosjobdsl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
