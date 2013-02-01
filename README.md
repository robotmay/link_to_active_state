# LinkToActiveState

[![Build Status](https://travis-ci.org/robotmay/link_to_active_state.png?branch=master)](https://travis-ci.org/robotmay/link_to_active_state) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/robotmay/link_to_active_state) [![Dependency Status](https://gemnasium.com/robotmay/link_to_active_state.png)](https://gemnasium.com/robotmay/link_to_active_state)

A simple gem to implement active states on links using the standard Rails `link_to` helper.

## Installation

Add this line to your application's Gemfile:

    gem 'link_to_active_state'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install link_to_active_state

## Usage

This gem adds a small bit of extra functionality to the default Rails `link_to` view helper. It provides a very simple way of adding classes to links based on the current path.

### Examples

Test the path using a string/path helper:
```ruby
link_to "Account", account_path, active_on: account_path
```

Using a regular expression:
```ruby
link_to "Account", account_path, active_on: /\/account/i
```

Or a proc:
```ruby
link_to "Account", account_path, active_on: lambda { request.fullpath == account_path }
```

### Custom options

By default the class "active" will be added to the existing classes of the link. However you can specify your own:

```ruby
link_to "Account", account_path, active_on: /\/account/i, active_state: "highlighted"
```

You can also customise other options by using a proc:
```ruby
link_to "Account", account_path, active_on: /\/account/i, active_state: lambda { |html_options|
  html_options.merge({ "data-active" => "true" })
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
