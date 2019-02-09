require 'tiny_promotions/models/item'
require 'tiny_promotions/promotions/client'

module TinyPromotions
  class Checkout
    attr_reader :items, :engine_client, :original_price, :tax_price
    attr_accessor :total, :discount

    def initialize(config={})
      @items = []
      reset_values!
      load_presets(config)
    end

    def scan(item)
      @items << item
      recalc!
      self
    end

    def recalc!
      reset_values!
      run_engines!
    end

    def history
      @engine_client.history
    end

    def original_price
      @original_price = @items.reduce(0.0) { |acc, item| acc += item.price; acc }
    end

    private

    def reset_values!
      @total = original_price
      @original_price = original_price
      @discount = 0.0
      true
    end

    def run_engines!
      @engine_client.call
    end

    def load_presets(config)
      @engine_client = TinyPromotions::Promotions::Client.new(config, self)
    end
  end
end
