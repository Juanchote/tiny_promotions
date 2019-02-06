module TinyPromotions::Promotions
  class Invoker
    attr_reader :history

    def call(cmd)
      @history ||= []
      cmd.call
      @history << cmd.result if cmd.applies?
    end
  end
end
