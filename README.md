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

| key     | type   | desc                      | example                                                                         
|---------|--------|---------------------------|------------------------------------------------------------------------------------------------
| path    | String | (optional) path for custom engines   | "../spec/engines"                                                               
| engines | Array  | Array of engines to apply | [{name: 'cart_total', discount: { type: 'percent', amount: 50}, validator: { min_total: 50 }}] 

Engine key:

| key      | type   | desc               | example                    
|----------|--------|--------------------|------------------------------------------------
| name     | String | name of the engine | "cart_total"
| discount | Hash   | discount Specs     | {type: 'fixed', amount: 10, apply_to: 'global'}

Validator key:

Custom keys based on the logic of the Validator.

CartTotal validator:

| key       | type    | desc                   | example
|-----------|---------|------------------------|--------
| min_total | Integer | min price of the cart | 50

MultipleItems validator:

| key       | type    | desc                   | example
|-----------|---------|------------------------|--------
| min_items | Integer | min items to apply     | 3
| code      | String  | code to match          | 'foo'


Discount Key:

| key      | type    | desc                          | example
|----------|---------|-------------------------------|--------------------------------------------------
| type     | String  | type of discount              | 'fixed' -> fixed amount, 'percent' -> percentage
| amount   | Float   | amount                        | 10.0
| apply_to | String  | Apply to all cart or to items | 'global' / 'item' 

Item: Cart Item

  TinyPromotions::Models::Item(code, desc, price)
params:

| key            | type   | desc                | example
|----------------|--------|---------------------|----
| code           | String | code of the product | "foo"
| desc           | String | description         | "Best product ever"
| price          | Float  | price               | 5.99
| original_price | Float  | original price      | 9.99

Engines:
[Command Pattern](https://en.wikipedia.org/wiki/Command_pattern).
Client: Client responsible of the logic of the pattern.
Invoker: Class for executing the commands
Engines: Commands with the logic of the promotions
Engines::Base: Abstract class of the commands

## Usage
Instantiate a new checkout:
```ruby
co = TinyPromotions::Checkout.new({
	engines: [
	{name: 'cart_total', discount: { type: 'percent', amount: 50, apply_to: 'global' }, validator: { min_total: 50}},
	{name: 'multiple_items', discount: { type: 'fixed', amount: 10, apply_to: 'global' }, validator: { code: 'foo', min_items: 2 }}
	]
})
=> #<TinyPromotions::Checkout:0x00007f91a8a49d18
 @discount=0.0,
 @engine_client=
  #<TinyPromotions::Promotions::Client:0x00007f91a8a49bb0
   @config=
    {:engines=>
      [{:name=>"cart_total", :discount=>{:type=>"percent", :amount=>50, :apply_to=>"global"}, :validator=>{:min_total=>50}},
       {:name=>"multiple_items", :discount=>{:type=>"fixed", :amount=>10, :apply_to=>"global"}, :validator=>{:code=>"foo", :min_items=>2}}]},
   @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
   @engines=
    [#<TinyPromotions::Promotions::Engine:0x00007f91a8a49a70
      @discount_processor=
       #<TinyPromotions::Promotions::DiscountProcessors::Global:0x00007f91a8a49ac0
        @config={:name=>"cart_total", :discount=>{:type=>"percent", :amount=>50, :apply_to=>"global"}, :validator=>{:min_total=>50}},
        @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
        @discount_rules={:type=>"percent", :amount=>50, :apply_to=>"global"}>,
      @validator=#<TinyPromotions::Promotions::Validators::CartTotal:0x00007f91a8a49ae8 @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>, @min_total=50>>,
     #<TinyPromotions::Promotions::Engine:0x00007f91a8a499d0
      @discount_processor=
       #<TinyPromotions::Promotions::DiscountProcessors::Global:0x00007f91a8a49a20
        @config={:name=>"multiple_items", :discount=>{:type=>"fixed", :amount=>10, :apply_to=>"global"}, :validator=>{:code=>"foo", :min_items=>2}},
        @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
        @discount_rules={:type=>"fixed", :amount=>10, :apply_to=>"global"}>,
      @validator=
       #<TinyPromotions::Promotions::Validators::MultipleItems:0x00007f91a8a49a48 @code="foo", @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>, @min_items=2>>],
   @invoker=#<TinyPromotions::Promotions::Invoker:0x00007f91a8a49b88>>,
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
=> #<TinyPromotions::Checkout:0x00007f91a8a49d18
 @discount=0.0,
 @engine_client=
  #<TinyPromotions::Promotions::Client:0x00007f91a8a49bb0
   @config=
    {:engines=>
      [{:name=>"cart_total", :discount=>{:type=>"percent", :amount=>50, :apply_to=>"global"}, :validator=>{:min_total=>50}},
       {:name=>"multiple_items", :discount=>{:type=>"fixed", :amount=>10, :apply_to=>"global"}, :validator=>{:code=>"foo", :min_items=>2}}]},
   @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
   @engines=
    [#<TinyPromotions::Promotions::Engine:0x00007f91a8a49a70
      @discount_processor=
       #<TinyPromotions::Promotions::DiscountProcessors::Global:0x00007f91a8a49ac0
        @config={:name=>"cart_total", :discount=>{:type=>"percent", :amount=>50, :apply_to=>"global"}, :validator=>{:min_total=>50}},
        @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
        @discount=50.0,
        @discount_rules={:type=>"percent", :amount=>50, :apply_to=>"global"},
        @total=100>,
      @validator=#<TinyPromotions::Promotions::Validators::CartTotal:0x00007f91a8a49ae8 @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>, @min_total=50>>,
     #<TinyPromotions::Promotions::Engine:0x00007f91a8a499d0
      @discount_processor=
       #<TinyPromotions::Promotions::DiscountProcessors::Global:0x00007f91a8a49a20
        @config={:name=>"multiple_items", :discount=>{:type=>"fixed", :amount=>10, :apply_to=>"global"}, :validator=>{:code=>"foo", :min_items=>2}},
        @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>,
        @discount_rules={:type=>"fixed", :amount=>10, :apply_to=>"global"}>,
      @validator=
       #<TinyPromotions::Promotions::Validators::MultipleItems:0x00007f91a8a49a48 @code="foo", @context=#<TinyPromotions::Checkout:0x00007f91a8a49d18 ...>, @min_items=2>>],
   @invoker=#<TinyPromotions::Promotions::Invoker:0x00007f91a8a49b88 @history=[]>>,
 @items=[#<TinyPromotions::Models::Item:0x00007f91a8bf1350 @code="foo", @name="desc", @original_price=100, @price=100>],
 @original_price=100,
 @total=50.0>
```

## Engines:
### Engines deployed with the gem.

#### CartTotal
This engine will discount the discount attribute based in the min_items attribute
Ex.
```ruby
{
  name: "cart_total",
  discount: { type: 'fixed', amount: 10, apply_to: 'global' }
  validator: { min_total: 50 }
}
```
This engine will discount $10 when the cart is equal or more than $50.

#### MultipleItems
Ex.
```ruby
{
  name: "multiple_items",
  discount: { type: 'percent', amount: 25, apply_to: 'global' }
  validator: { min_items: 2, code: 'foo' }
}
```
This engine will discount the discount attribute if there are are at least 2 items with code "foo".

### Create your own Promotion Engine.
Create a new file that extends from

	TinyPromotions::Promotions::Validators::Base
	
Define 

	#post_initialize(rules)
where you can set the attributes you are going to need (discount, total are already set by the Base class).

Define 

	#applies?

method where you are going to set when to apply the discount or not.

Ex. Creating a new Engine that will discount when at least 1 product "foo" and 2 products "bar" are in the cart.
```ruby
class FooBars < TinyPromotions::Promotions::Validators::Base
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
  path: "./examples",
  engines: [{name: 'foo_bars', validator: { code_1: 'foo', min_product_1: 1, code_2: 'bar', min_product_2: 2 }, discount: {type: 'fixed', amount: 10, apply_to: 'global'}}]
})
```
Start adding items to the checkout and see the result.

