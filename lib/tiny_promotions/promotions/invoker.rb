module TinyPromotions::Promotions
  class Invoker
    attr_reader :history

    def purge!
      history = []
    end

    def call(cmd)
      @history ||= []
      cmd.call
      @history << cmd.result if cmd.applies?
    end

    def log
      @history
    end
  end
end
