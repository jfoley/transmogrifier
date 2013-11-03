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

      it "accepts nodes" do
        node = HashNode.new("key" => "value")
        Node.for(node).should be_a(HashNode)
      end
    end
  end

  describe ValueNode do
    describe "#raw" do
      it "returns the passed in value" do
        node = ValueNode.new("hello")
        expect(node.raw).to eq("hello")
      end
    end

    describe "#delete" do
      it "raises a NotImplementedError" do
        expect {
          ValueNode.new("hello").delete("key")
        }.to raise_error(NotImplementedError)
      end
    end

    describe "#append" do
      it "raises a NotImplementedError" do
        expect {
          ValueNode.new("hello").append("value")
        }.to raise_error(NotImplementedError)
      end
    end
  end

  describe HashNode do
    describe "#raw" do
      it "returns the passed in hash" do
        node = HashNode.new({"key" => "value"})
        expect(node.raw).to eq({"key" => "value"})
      end
    end

    describe "#find_all" do
      it "returns wildcard matches" do
        node = HashNode.new({"key1" => "value"})

        expect(node.find_all(["*"]).map(&:raw)).to eq(["value"])
      end

      it "returns wildcard matches" do
        node = HashNode.new({"key1" => {"key2" => "value"}})

        expect(node.find_all(["key1", "*"]).map(&:raw)).to eq(["value"])
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

        expect(node.delete("extra_key").raw).to eq("other_value")
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

  describe ArrayNode do
    describe "#raw" do
      it "returns the underlying array" do
        array = [{"name" => "object1"}, {"name" => "object2"}]
        node = ArrayNode.new(array)
        expect(node.raw).to eq(array)
      end
    end

    describe "#find_all" do
      it "returns wildcard matches" do
        array = [{"name" => "object1", "nested" => {"key1" => "value1"}}, {"name" => "object2",  "nested" => {"key2" => "value2"}}]
        node = ArrayNode.new(array)

        expect(node.find_all(["*", "nested"]).map(&:raw)).to eq([{"key1" => "value1"}, {"key2" => "value2"}])
      end

      it "filters by attributes" do
        array = [{"type" => "object", "key1" => "value1"}, {"type" => "object", "key2" => "value2"}]
        node = ArrayNode.new(array)

        expect(node.find_all([{"type" => "object"}]).map(&:raw)).to eq(array)
      end
    end

    describe "#delete" do
      it "deletes the node from the array" do
        array = [{"name" => "object1"}, {"name" => "object2"}]
        node = ArrayNode.new(array)
        expect(node.delete({"name" => "object1"}).raw).to eq({"name" => "object1"})
      end
    end

    describe "#append" do
      it "appends the node to the array" do
        array = [{"name" => "object1"}]
        node = ArrayNode.new(array)
        node.append("name" => "object2")
        expect(node.raw).to eq([{"name" => "object1"}, {"name" => "object2"}])
      end
    end
  end
end