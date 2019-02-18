require 'pry'

RSpec.describe TinyPromotions::Checkout do
  let(:item_foo_1) { TinyPromotions::Models::Item.new("foo", "foo", 40) }
  let(:item_foo_2) { TinyPromotions::Models::Item.new("foo", "foo", 40) }
  let(:item_bar_1) { TinyPromotions::Models::Item.new("bar", "bar", 40) } 

  describe "with 2 same products" do
    let(:discount_config) {
      { engines: [{name: 'multiple_items', discount: {type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_items: 2, code: 'foo'}}] }
    }

    let(:percent_discount_config) {
      { engines: [{name: 'multiple_items', discount: {type: 'percent', amount: 50, apply_to: 'global'}, validator: {min_items: 2, code: 'foo'}}] }
    }

    let(:no_discount_config) {
      { engines: [{name: 'cart_total', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_total: 200}}] }
    }

    it "expect to discount $10" do
      calc_checkouts(discount_config, 70, item_foo_1, item_foo_2)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, 80, item_foo_1, item_foo_2)
    end

    it "expect to discount 50% of total" do
      calc_checkouts(percent_discount_config, 40, item_foo_1, item_foo_2)
    end
  end

  describe "with 2 items total more than $50" do
    let(:discount_config) {
      { engines: [{name: 'cart_total', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_total: 50 }}] }
    }

    let(:no_discount_config) {
      { engines: [{name: 'cart_total', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_total: 100 }}]  }
    }

    it "expect to discount $10" do
      calc_checkouts(discount_config, 70, item_foo_1, item_bar_1)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, 80, item_foo_1, item_bar_1)
    end
  end

  describe "with 2 same products and 1 diff product" do
    let(:discount_config) {
      { engines: [{name: 'cart_total', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_total: 50 }},
       {name: 'multiple_items', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_items: 2, code: 'foo' }}] }
    }

    let(:no_discount_config) {
      { engines: [] }
    }

    it "expect to discount $20" do
      calc_checkouts(discount_config, 100, item_foo_1, item_bar_1, item_foo_2)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, 120, item_foo_1, item_bar_1, item_foo_2)
    end
  end

  describe "with fixed and percent discount at the same time" do
    let(:discount_config) {
      { engines: [{name: 'cart_total', discount: { type: 'percent', amount: 50, apply_to: 'global'}, validator: { min_total: 50 }},
       {name: 'multiple_items', discount: { type: 'fixed', amount: 10, apply_to: 'global'}, validator: { min_items: 2, code: 'foo' }}] }
    }
    it "expect to first discount by % and then by fixed" do
      calc_checkouts(discount_config, 50, item_foo_1, item_bar_1, item_foo_2)
    end
  end

  describe "Examples from test" do
    let(:discount_config) do
      { engines: [
        { name: 'multiple_items',
         discount: { type: 'fixed', apply_to: 'item', amount: 0.75 },
         validator: { min_items: 2, code: '001' } },
        { name: 'cart_total',
         discount: { type: 'percent', amount: 10, apply_to: 'global'},
         validator: { min_total: 60 } }
        ]
      }
    end
    let(:item_001) { TinyPromotions::Models::Item.new("001", "Lavender Heart", 9.25) }
    let(:item_002) { TinyPromotions::Models::Item.new("002", "Personalied cufflinks", 45.00) }
    let(:item_003) { TinyPromotions::Models::Item.new("003", "Kids T-Shirt", 19.95) } 

    it "with product 001, 002, 003 expect price 66.78" do
      calc_checkouts(discount_config, 66.78, item_001, item_002, item_003)
    end

    it "with product 001, 003, 001 expect price 36.95" do
      calc_checkouts(discount_config, 36.95, item_001, item_003, item_001)
    end

    it "with product 001, 002, 001, 003 expect price 73.76" do
      calc_checkouts(discount_config, 73.755, item_001, item_002, item_001, item_003)
    end
  end

  private

  def calc_checkouts(config, total, *items)
    TinyPromotions::Checkout.new(config).tap { |co|
      items.each { |item| co.scan(item) }
      expect(co.total).to eq(total)
    }
  end
end
