RSpec.describe TinyPromotions::Promotions::Client do
  describe "with a given configuration" do
    let(:cart_total_config) { [{name: 'cart_total', discount: 10, min_items: 2}] }

    it "expect to load CartTotal engine" do
      client = TinyPromotions::Promotions::Client.new(cart_total_config, nil)

      expect(client.engines.size).to eq(1)
      expect(client.engines[0]).to be_kind_of(TinyPromotions::Promotions::Engines::CartTotal) 
    end
  end
end
