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

  describe ValueNode do
    describe "#raw" do
      it "returns the passed in value" do
        node = ValueNode.new("hello")
        expect(node.raw).to eq("hello")
      end
    end

    describe "#find_all" do
      context "when given empty keys" do
        it "returns an array of itself" do
          node = ValueNode.new("hello")
          expect(node.find_all([])).to eq([node])
        end
      end

      context "when given non-empty keys" do
        it "raises an error" do
          node = ValueNode.new("hello")
          expect {
            node.find_all(["foo.bar"])
          }.to raise_error
        end
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

        expect(node.find_all([[], "nested"]).map(&:raw)).to eq([{"key1" => "value1"}, {"key2" => "value2"}])
      end

      it "filters by attributes" do
        array = [{"type" => "object", "key1" => "value1"}, {"type" => "object", "key2" => "value2"}]
        node = ArrayNode.new(array)

        expect(node.find_all([{"type" => "object"}]).map(&:raw)).to eq(array)
      end
    end

    describe "#delete" do
      context "when one node matches the criteria" do
        it "deletes the node from the array" do
          array = [{"name" => "object1"}, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.delete({"name" => "object1"})).to eq({"name" => "object1"})
        end
      end

      context "when more than one node matches the criteria" do
        it "raises an error" do
          array = [{"name" => "object1", "common_key" => "common_value"}, {"name" => "object2", "common_key" => "common_value"}]
          node = ArrayNode.new(array)
          expect {
            node.delete({"common_key" => "common_value"})
          }.to raise_error
        end
      end

      context "when no nodes match the criteria" do
        it "returns nil" do
          array = [{"name" => "object1"}, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.delete({"name" => "not_present"})).to be_nil
        end
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
