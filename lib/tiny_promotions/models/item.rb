module TinyPromotions::Models
  class Item
    attr_reader :code, :name, :original_price
    attr_accessor :price

    def initialize(code, name, price)
      @code, @name, @original_price, @price = code, name, price, price
    end

    def update_price(price)
      @price = price
    end
  end
end
