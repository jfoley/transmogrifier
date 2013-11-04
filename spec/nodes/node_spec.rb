require "transmogrifier"

module Transmogrifier
  describe Node do
    describe ".for" do
      it "returns a node value" do
        Node.for("value").should be_a(ValueNode)
      end

      it "returns a hash value" do
        Node.for("key" => "value").should be_a(HashNode)
      end

      it "returns an array value" do
        Node.for(["value"]).should be_a(ArrayNode)
      end
    end
  end
end
