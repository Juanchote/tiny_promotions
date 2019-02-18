module TinyPromotions::Promotions
  class Engine
    attr_reader :validator, :discount_processor

    def initialize(params={})
      @validator          = params.fetch(:validator)
      @discount_processor = params.fetch(:discount_processor)
    end
  end
end
