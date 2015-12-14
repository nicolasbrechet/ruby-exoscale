[![Gem Version](https://badge.fury.io/rb/exoscale.svg)](https://badge.fury.io/rb/exoscale)

# Ruby Exoscale

Simple Ruby gem to access Exoscale's API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exoscale'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exoscale

## Usage

All methods are described on [Exoscale's documentation](https://community.exoscale.ch/api/). As this is a Ruby gem, all methods are snake_cased. 


### Compute
```
require 'exoscale'
exo = Exoscale::Compute.new(ENV['EXO_API_KEY'], ENV['EXO_API_SECRET_KEY'])
puts exo.list_zones
puts exo.list_virtual_machines

```


### DNS

```
require 'exoscale'
exo = Exoscale::Compute.new(ENV['EXO_API_KEY'], ENV['EXO_API_SECRET_KEY'])
puts exo.list_domains
puts exo.create_domain('example.com')
puts exo.create_record('example.com', 'www', 'A', '1.2.3.4')

```


### Apps

To do...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicolasbrechet/ruby-exoscale. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

