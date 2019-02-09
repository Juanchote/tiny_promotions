require 'pry'
RSpec.describe TinyPromotions::Checkout do
  let(:item_foo_1) { TinyPromotions::Models::Item.new("foo", "foo", 40) }
  let(:item_foo_2) { TinyPromotions::Models::Item.new("foo", "foo", 40) }
  let(:item_bar_1) { TinyPromotions::Models::Item.new("bar", "bar", 40) } 

  describe "with 2 same products" do
    let(:discount_config) {
      [{name: 'multiple_items', discount: 10, min_items: 2, code: 'foo'}] 
    }

    let(:no_discount_config) {
      [{name: 'cart_total', discount: 10, min_total: 200}] 
    }

    it "expect to discount $10" do
      calc_checkouts(discount_config, item_foo_1, item_foo_2)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, item_foo_1, item_foo_2)
    end
  end

  describe "with 2 items total more than $50" do
    let(:discount_config) {
      [{name: 'cart_total', discount: 10, min_total: 50}] 
    }

    let(:no_discount_config) {
      [{name: 'cart_total', discount: 10, min_total: 100}] 
    }

    it "expect to discount $10" do
      calc_checkouts(discount_config, item_foo_1, item_bar_1)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, item_foo_1, item_bar_1)
    end
  end

  describe "with 2 same products and 1 diff product" do
    let(:discount_config) {
      [{name: 'cart_total', discount: 10, min_total: 50},
       {name: 'multiple_items', discount: 10, min_items: 2}] 
    }

    let(:no_discount_config) {
     []
    }

    it "expect to discount $20" do
      calc_checkouts(discount_config, item_foo_1, item_bar_1, item_foo_2)
    end

    it "expect the same price" do
      calc_checkouts(no_discount_config, item_foo_1, item_bar_1, item_foo_2)
    end
  end

  private

  def calc_checkouts(config, *items)
    TinyPromotions::Checkout.new(config).tap { |co|
      items.each { |item| co.scan(item) }
      expect(co.total).to eq(co.original_price - co.discount)
    }
  end
end
