module TinyPromotions::Promotions::History
  class LogResult
    attr_reader :message

    def initialize(engine)
      @message = "Applied engine: #{engine.class}"
    end
  end
end
