# TinyPromotions

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiny_promotions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiny_promotions

## Overview
Checkout: Main class.
Accept 1 config hash.
Config: Hash with the following attributes:
path: String with the path of custom engines || nil
config: Array of engines for configuring the checkout.

Engines:
Command pattern.
Client: Client responsible of the logic of the pattern.
Invoker: Class for executing the commands
Engines: Commands with the logic of the promotions
Engines::Base: Interface of the commands



## Usage



Engines:
## Engines deployed with the gem.

### CartTotal
This engine will discount the discount attribute based in the min_items attribute
Ex.
{
  name: "cart_total",
  discount: 10,
  min_total: 50,
}
This engine will discount $10 when the cart is equal or more than $50.

### MultipleItems
Ex.
{
  name: "multiple_items",
  discount: 25,
  min_items: 2,
  code: 'foo'
}
This engine will discount the discount attribute if there are are at least 2 items with code "foo".

## Create your own Promotion Engine.
Create a new file that extends from TinyPromotions::Promotions::Engines::Base
Define #post_initialize method(rules) where you can set the attributes you are going to need (discount, total are already set by the Base class).
Define #applies? method where you are going to set when to apply the discount or not.

Ex. Creating a new Engine that will discount when at least 1 product "foo" and 2 products "bar" are in the cart.
class FooBars < TinyPromotions::Promotions::Engines::Base
  attr_reader :min_product_1, :code_1, :min_product_2, :code_2

  def post_initialize(rules)
    @min_product_1, @code_1, @min_product_2, @code_2 = rules.dig(:min_product_1),
         rules.dig(:code_1), rules.dig(:min_product_2), rules.dig(:code_2)
  end

  def applies?
    @context.items.select{ |item| item.code.equals?(@code_1) }.count {|items| items >= @min_product_1 } && @context.items.select{ |item| item.code.equals?(@code_2) }.count {|items| items >= @min_product_2 }
  end
end

Now inject the new engine to a checkout.
TinyPromotions::Checkout.new({
  path: "/path/to/engines",
  engines: [{name: 'foo_bars', code_1: 'foo', min_product_1: 1, code_2: 'bar', min_product_2: 2}]
})

Start adding items to the checkout and see the result.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tiny_promotions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TinyPromotions project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tiny_promotions/blob/master/CODE_OF_CONDUCT.md).
