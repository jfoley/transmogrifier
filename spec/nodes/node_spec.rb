require "transmogrifier"

module Transmogrifier
  describe Node do
    describe ".for" do
      it "returns a node value" do
        expect(Node.for("value")).to be_a(ValueNode)
      end

      it "returns a hash value" do
        expect(Node.for("key" => "value")).to be_a(HashNode)
      end

      it "returns an array value" do
        expect(Node.for(["value"])).to be_a(ArrayNode)
      end
    end
  end
end
