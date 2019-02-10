RSpec.describe TinyPromotions::Promotions::Client do
  describe "with a given configuration" do
    let(:cart_total_config) { 
      { path: nil, engines: [{name: 'cart_total', discount: { type: 'fixed', amount: 10}, min_items: 2}] }
    }

    let(:foo_bars_config) { 
      { path: 'spec/test_engines', engines: [{name: 'foo_bars', discount: { type: 'fixed', amount: 10}, code_1: 'foo', min_product_1: 1, code_2: 'bar', min_produc_2: 2}] }
    }

    it "expect to load CartTotal engine" do
      client = TinyPromotions::Promotions::Client.new(cart_total_config, nil)

      expect(client.engines.size).to eq(1)
      expect(client.engines[0]).to be_kind_of(TinyPromotions::Promotions::Engines::CartTotal) 
    end

    xit "expect to load new path" do

    end
  end
end
