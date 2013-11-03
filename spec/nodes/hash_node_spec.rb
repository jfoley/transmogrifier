require "transmogrifier"

module Transmogrifier
  describe HashNode do
    describe "#raw" do
      it "returns the passed in hash" do
        node = HashNode.new({"key" => "value"})
        expect(node.raw).to eq({"key" => "value"})
      end
    end

    describe "#delete" do
      it "deletes the given key" do
        hash = {"key" => "value", "extra_key" => "other_value"}
        node = HashNode.new(hash)
        node.delete("extra_key")

        expect(node.raw).to eq({"key" => "value"})
      end

      it "returns the node that was deleted" do
        hash = {"key" => "value", "extra_key" => "other_value"}
        node = HashNode.new(hash)

        expect(node.delete("extra_key")).to eq("other_value")
      end
    end

    describe "#append" do
      it "appends the given node at the key" do
        hash = {"key" => "value"}
        node = HashNode.new(hash)
        node.append({ "extra_key" => "extra_value"})
        expect(node.raw).to eq({"key" => "value", "extra_key" => "extra_value"})
      end
    end
  end
end
