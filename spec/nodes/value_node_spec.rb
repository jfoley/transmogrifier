require "transmogrifier"

module Transmogrifier
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

    describe "#clone" do
      it "raises a NotImplementedError" do
        expect {
          ValueNode.new("hello").clone("key")
        }.to raise_error(NotImplementedError)
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

    describe "#modify" do
      context "when pattern matches" do
        it "modifies the value based on simple pattern" do
          node = ValueNode.new("value")
          expect(node.modify("al", "og")).to eq("vogue")
          expect(node.raw).to eq("vogue")
        end

        it "modifies the value based on complex pattern" do
          node = ValueNode.new("valllue")
          expect(node.modify("a.*u", "ogu")).to eq("vogue")
          expect(node.raw).to eq("vogue")
        end
      end

      context "when pattern does not match" do
        it "does not modify value"  do
          node = ValueNode.new("value")
          expect(node.modify("ss", "og")).to be_nil
          expect(node.raw).to eq("value")
        end
      end
    end
  end
end
