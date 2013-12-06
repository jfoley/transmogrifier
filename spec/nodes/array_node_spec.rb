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

      context "when attribute filters are specified" do
        it "filters using '=='" do
          array = [
            {"type" => "object", "key1" => "value1"},
            {"type" => "object", "key2" => "value2"},
          ]
          node = ArrayNode.new(array)

          expect(node.find_all([[["==", "type", "object"]]]).map(&:raw)).to eq(array)
        end

        it "filters using '!='" do
          array = [
            {"type" => "object1", "key1" => "value1"},
            {"type" => "object2", "key2" => "value2"},
          ]
          node = ArrayNode.new(array)

          expect(node.find_all([[["!=", "type", "object1"]]]).map(&:raw)).to eq(array.slice(1,1))
        end

        it "filters using '!=' and '=='" do
          array = [
            {"type" => "object1", "key1" => "value1"},
            {"type" => "object2", "key2" => "value2"},
            {"type" => "object3", "key3" => "value3"},
          ]
          node = ArrayNode.new(array)

          expect(node.find_all([[["!=", "type", "object1"],["==", "type", "object2"]]]).map(&:raw)).to eq(array.slice(1,1))
        end

        it "raises ArgumentError for unknown operators" do
          array = [
            {"type" => "object1", "key1" => "value1"},
            {"type" => "object2", "key2" => "value2"},
          ]
          node = ArrayNode.new(array)

          expect{node.find_all([[["~", "type", "object1"]]])}.to raise_error
          expect{node.find_all([[["value"]]])}.to raise_error
        end
      end
    end

    describe "#clone" do
      context "when one node matches the criteria" do
        it "returns the node from the array" do
          value = {"name" => "object1"}
          array = [value, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.clone([["==", "name", "object1"]])).to eq(value)
          expect(node.clone([["==", "name", "object1"]])).to_not be(value)
        end
      end

      context "when more than one node matches the criteria" do
        it "raises an error" do
          array = [{"name" => "object1", "common_key" => "common_value"}, {"name" => "object2", "common_key" => "common_value"}]
          node = ArrayNode.new(array)
          expect {
            node.clone([["==", "common_key", "common_value"]])
          }.to raise_error
        end
      end

      context "when no nodes match the criteria" do
        it "returns nil" do
          array = [{"name" => "object1"}, {"name" => "object2"}]
          node = ArrayNode.new(array)
          expect(node.clone([["==", "name", "not_present"]])).to be_nil
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
          expect(node.delete([["==", "name", "object1"]])).to eq({"name" => "object1"})
        end
      end

      context "when more than one node matches the criteria" do
        it "deletes all matching nodes from array" do
          array = [
            {"name" => "object1", "common_key" => "common_value"},
            {"name" => "object2", "common_key" => "common_value"},
          ]
          node = ArrayNode.new(array.clone)
          expect(node.delete([["==", "common_key", "common_value"]])).to eq(array)
        end
      end

      context "when no nodes match the criteria" do
        it "returns nil" do
          array = [
            {"name" => "object1"},
            {"name" => "object2"},
          ]
          node = ArrayNode.new(array)
          expect(node.delete([["==", "name", "not_present"]])).to be_nil
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

    describe "#modify" do
      it "raises a NotImplementedError" do
        expect {
          ArrayNode.new("hello").modify("value", "value2")
        }.to raise_error(NotImplementedError)
      end
    end
  end
end
