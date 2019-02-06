require 'tiny_promotions/models/item'

RSpec.describe TinyPromotions::Models::Item do
  describe "Create a new Item" do
    it "with invalid data it should raise exception" do
      expect{ TinyPromotions::Models::Item.new }.to raise_error(ArgumentError)
    end
  end  
end
