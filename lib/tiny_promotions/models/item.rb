module TinyPromotions::Models
  class Item
    attr_reader :price, :code, :name

    def initialize(code, name, price)
      @code, @name, @price = code, name, price
    end
  end
end
