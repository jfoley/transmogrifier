require "transmogrifier"

module Transmogrifier
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
        array = [
          {"name" => "object1", "nested" => {"key1" => "value1"}},
          {"name" => "object2",  "nested" => {"key2" => "value2"}}
        ]
        node = ArrayNode.new(array)

        expect(node.find_all([[], "nested"]).map(&:raw)).to eq([
          {"key1" => "value1"},
          {"key2" => "value2"},
        ])
      end

      it "filters by attributes" do
        array = [
          {"type" => "object", "key1" => "value1"},
          {"type" => "object", "key2" => "value2"},
        ]
        node = ArrayNode.new(array)

        expect(node.find_all([["type", "object"]]).map(&:raw)).to eq(array)
      end
    end

    describe "#clone" do
      context "when one node matches the criteria" do
        it "returns the node from the array" do
          value = {"name" => "object1"}
          array = [value, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.clone([["name", "object1"]])).to eq(value)
          expect(node.clone([["name", "object1"]])).to_not be(value)
        end
      end

      context "when more than one node matches the criteria" do
        it "raises an error" do
          array = [{"name" => "object1", "common_key" => "common_value"}, {"name" => "object2", "common_key" => "common_value"}]
          node = ArrayNode.new(array)
          expect {
            node.clone([["common_key", "common_value"]])
          }.to raise_error
        end
      end

      context "when no nodes match the criteria" do
        it "returns nil" do
          array = [{"name" => "object1"}, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.clone([["name", "not_present"]])).to be_nil
        end
      end
    end


    describe "#delete" do
      context "when one node matches the criteria" do
        it "deletes the node from the array" do
          array = [
            {"name" => "object1"},
            {"name" => "object2"},
          ]
          node = ArrayNode.new(array)
          expect(node.delete([["name", "object1"]])).to eq({"name" => "object1"})
        end
      end

      context "when more than one node matches the criteria" do
        it "raises an error" do
          array = [
            {"name" => "object1", "common_key" => "common_value"},
            {"name" => "object2", "common_key" => "common_value"},
          ]
          node = ArrayNode.new(array)
          expect {
            node.delete([["common_key", "common_value"]])
          }.to raise_error
        end
      end

      context "when no nodes match the criteria" do
        it "returns nil" do
          array = [
            {"name" => "object1"},
            {"name" => "object2"},
          ]
          node = ArrayNode.new(array)
          expect(node.delete([["name", "not_present"]])).to be_nil
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
