# AccumuloVisibilityParser

A Ruby Gem to parse Accumulo Visibility Strings

## Installation

Add this line to your application's Gemfile:

    gem 'accumulo_visibility_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install accumulo_visibility_parser

## Usage

This gem is designed to be used for parsing Accumulo Column
Visibility strings and optionally evaluating against an array of
Authorizations.  It **SHOULD NOT** be used to protect data.  This gem
is not guarenteed to use the same logic as Accumulo to protect your
data.  Additionally, this gem has only been tested against Accumulo
1.4.  It may not work correctly against other versions.

Use this gem after data has already been returned with proper security
controls. A proper example usage is the UI layer in a Rails
application where you want to change the way data is displayed based
on visiblity.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
