require "transmogrifier"

describe Transmogrifier::Selector do
  describe "#keys" do
    it "returns empty array for a blank string" do
      expect(described_class.from_string("").keys).to eq([])
    end

    it "splits string separated by dots" do
      expect(described_class.from_string("foo.bar").keys).to eq(["foo", "bar"])
    end

    it "allows filtering by attribute" do
      expect(described_class.from_string("[attr1=val1,attr2=val2]").keys).to eq([[["=", "attr1", "val1"],["=", "attr2", "val2"]]])
    end

    it "allows filtering by attribute with not-equal comparison" do
      expect(described_class.from_string("[attr1!=val1,attr2!=val2]").keys).to eq([[["!=", "attr1", "val1"],["!=", "attr2", "val2"]]])
    end

    it "allows empty array" do
      expect(described_class.from_string("[]").keys).to eq([[]])
    end

    it "returns array filter with the whole value for unknown or missing operator" do
      expect(described_class.from_string("[attr1,attr2~val2]").keys).to eq([[["attr1"], ["attr2~val2"]]])
    end

    it "combines hash and array filtering" do
      expect(described_class.from_string("foo.[attr=val,attr!=val1]").keys).to eq(["foo", [["=", "attr", "val"],["!=", "attr", "val1"]]])
      expect(described_class.from_string("[attr=val,attr!=val1].bar").keys).to eq([[["=", "attr", "val"],["!=", "attr", "val1"]], "bar"])
    end
  end
end
