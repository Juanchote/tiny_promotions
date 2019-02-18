module TinyPromotions::Promotions
  class Invoker
    attr_reader :history

    def purge!
      @history = []
    end

    def call(cmd)
      @history ||= []
      cmd.call
    end

    def log
      @history
    end
  end
end
