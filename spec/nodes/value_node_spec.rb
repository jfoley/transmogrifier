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
end
