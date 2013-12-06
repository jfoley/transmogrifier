require "transmogrifier"

module Transmogrifier
  describe HashNode do
    describe "#raw" do
      it "returns the passed in hash" do
        node = HashNode.new({"key" => "value"})
        expect(node.raw).to eq({"key" => "value"})
      end
    end

    describe "#find_all" do
      context "given an empty set of selector keys" do
        it "returns itself in an array" do
          hash = {
            "key" => "value",
            "extra_key" => "other_value",
          }
          node = HashNode.new(hash)

          expect(node.find_all([]).map(&:raw)).to eq([{
            "key" => "value",
            "extra_key" => "other_value",
          }])
        end
      end

      context "given multiple selector keys" do
        let(:keys) { ["key", [["=", "k", "v"]]] }

        context "when the first key is a key in the hash" do
          let(:hash) {{
            "key" => [
              {"k" => "v", "a" => "b"},
              {"k" => "not_v", "c" => "d"},
              {"k" => "v", "e" => "f"},
            ]
          }}

          it "finds all children of the first key's value satisfying the remaining selector keys" do
            node = HashNode.new(hash)

            expect(node.find_all(keys).map(&:raw)).to eq([
              {"k" => "v", "a" => "b"},
              {"k" => "v", "e" => "f"}
            ])
          end
        end

        context "when the first key is not a key in the hash" do
          let(:hash) {{
            "not_key" => [
              {"k" => "v", "a" => "b"},
              {"k" => "not_v", "c" => "d"},
              {"k" => "v", "e" => "f"}
            ]
          }}

          it "returns an empty array" do
            node = HashNode.new(hash)

            expect(node.find_all(keys).map(&:raw)).to eq([])
          end
        end
      end
    end

    describe "#clone" do
      it "returns a copy of value" do
        value = "other_value"
        hash = {"key" => "value", "extra_key" => value}
        node = HashNode.new(hash)

        expect(node.clone("extra_key")).to eql(value)
        expect(node.clone("extra_key")).to_not be(value)
        expect(node.raw).to eq("key" => "value", "extra_key" => "other_value")
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

    describe "#modify" do
      it "raises a NotImplementedError" do
        expect {
          HashNode.new("hello").modify("value", "value2")
        }.to raise_error(NotImplementedError)
      end
    end
  end
end
