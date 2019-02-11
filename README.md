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

	TinyPromotions::Checkout.new(config)
Config:
| key     | type   | desc                      | example                                                                         |
|---------|--------|---------------------------|---------------------------------------------------------------------------------|
| path    | String | path for custom engines   | "../spec/engines"                                                               |
| engines | Array  | Array of engines to apply | [{name: 'cart_total', discount: { type: 'percent', amount: 50}, min_total: 50}] |
Engines:
[Command Pattern](https://en.wikipedia.org/wiki/Command_pattern).
Client: Client responsible of the logic of the pattern.
Invoker: Class for executing the commands
Engines: Commands with the logic of the promotions
Engines::Base: Abstract class of the commands

## Usage
Instantiate a new checkout:
```ruby
co = TinyPromotions::Checkout.new({ path: nil,
	engines: [
	{name: 'cart_total', discount: { type: 'percent', amount: 50}, min_total: 50},
	{name: 'multiple_items', discount: { type: 'fixed', amount: 10}, code: 'foo', min_items: 2}
	]
})
#=> #<TinyPromotions::Checkout:0x00007f9e7f224398
 @discount=0.0,
 @engine_client=
  #<TinyPromotions::Promotions::Client:0x00007f9e7f2242a8
   @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
   @engines=
    [#<TinyPromotions::Promotions::Engines::CartTotal:0x00007f9e7f224190
      @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
      @discount_rules={:type=>"percent", :amount=>50},
      @min_total=50>,
     #<TinyPromotions::Promotions::Engines::MultipleItems:0x00007f9e7f2240f0
      @code="foo",
      @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
      @discount_rules={:type=>"fixed", :amount=>10},
      @min_items=2>],
   @invoker=#<TinyPromotions::Promotions::Invoker:0x00007f9e7f224280>>,
 @items=[],
 @original_price=0.0,
 @total=0.0>
```
Start adding 

	TinyPromotions::Models::Item 

to the checkout using

	#scan
```ruby
	co.scan(TinyPromotions::Models::Item.new("code", "desc", price))
```	

Ex.
```ruby
co.scan(TinyPromotions::Models::Item.new("foo", "desc", 100))
=> #<TinyPromotions::Checkout:0x00007f9e7f224398
 @discount=50.0,
 @engine_client=
  #<TinyPromotions::Promotions::Client:0x00007f9e7f2242a8
   @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
   @engines=
    [#<TinyPromotions::Promotions::Engines::CartTotal:0x00007f9e7f224190
      @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
      @discount=50.0,
      @discount_rules={:type=>"percent", :amount=>50},
      @min_total=50,
      @total=100>,
     #<TinyPromotions::Promotions::Engines::MultipleItems:0x00007f9e7f2240f0
      @code="foo",
      @context=#<TinyPromotions::Checkout:0x00007f9e7f224398 ...>,
      @discount_rules={:type=>"fixed", :amount=>10},
      @min_items=2,
      @total=100>],
   @invoker=
    #<TinyPromotions::Promotions::Invoker:0x00007f9e7f224280
     @history=
      [#<TinyPromotions::Promotions::History::LogResult:0x00007f9e8095f058
        @message="Applied engine: TinyPromotions::Promotions::Engines::CartTotal">]>>,
 @items=
  [#<TinyPromotions::Models::Item:0x00007f9e8095f5d0
    @code="foo",
    @name="desc",
    @price=100>],
 @original_price=100.0,
 @total=50.0>
```
## The Checkout Response:
```ruby
=> #<TinyPromotions::Checkout:0x00007f9e7f224398
 @discount=50.0, #total discount applied
 @engine_client=
  #<TinyPromotions::Promotions::Client: #comman client
   @context=#<TinyPromotions::Checkout: ...>, #checkout reference
   @engines= #List of engines to apply
    [#<TinyPromotions::Promotions::Engines::CartTotal:
      @context=#<TinyPromotions::Checkout: ...>, #checkout reference
      @discount=50.0, #engine's discount applied to the current cart (if any)
      @discount_rules= #config of the engine
	      {:type=>"percent", :amount=>50},
	      @min_total=50,
	      @total=100>,
     #<TinyPromotions::Promotions::Engines::MultipleItems:
      @code="foo",
      @context=#<TinyPromotions::Checkout: ...>, #checkout reference
      @discount_rules= #config of the engine
	      {:type=>"fixed", :amount=>10},
	      @min_items=2,
	      @total=100>],
   @invoker= #Invoker of engines (commands)
    #<TinyPromotions::Promotions::Invoker:
     @history= #Log of discounts successfully applied
      [#<TinyPromotions::Promotions::History::LogResult:
        @message="Applied engine: TinyPromotions::Promotions::Engines::CartTotal">]>>,
 @items= #Array of products in the cart
  [#<TinyPromotions::Models::Item:
    @code="foo",
    @name="desc",
    @price=100>],
 @original_price=100.0, #price without discounts
 @total=50.0> #original_price - discount
```

## Engines:
### Engines deployed with the gem.

#### CartTotal
This engine will discount the discount attribute based in the min_items attribute
Ex.
```ruby
{
  name: "cart_total",
  discount: 10,
  min_total: 50,
}
```
This engine will discount $10 when the cart is equal or more than $50.

#### MultipleItems
Ex.
```ruby
{
  name: "multiple_items",
  discount: 25,
  min_items: 2,
  code: 'foo'
}
```
This engine will discount the discount attribute if there are are at least 2 items with code "foo".

### Create your own Promotion Engine.
Create a new file that extends from

	TinyPromotions::Promotions::Engines::Base
	
Define 

	#post_initialize(rules)
where you can set the attributes you are going to need (discount, total are already set by the Base class).

Define 

	#applies?

method where you are going to set when to apply the discount or not.

Ex. Creating a new Engine that will discount when at least 1 product "foo" and 2 products "bar" are in the cart.
```ruby
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
```
Now inject the new engine to a checkout.
```ruby
TinyPromotions::Checkout.new({
  path: "/path/to/engines",
  engines: [{name: 'foo_bars', code_1: 'foo', min_product_1: 1, code_2: 'bar', min_product_2: 2}]
})
```
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


