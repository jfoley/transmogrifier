require "transmogrifier"

describe Transmogrifier::Selector do
  describe "#keys" do
    it "returns empty array for a blank string" do
      described_class.from_string("").keys.should == []
    end

    it "splits string separated by dots" do
      described_class.from_string("foo.bar").keys.should == ["foo", "bar"]
    end

    it "allows filtering by attribute" do
      described_class.from_string("[attr1==val1,attr2==val2]").keys.should == [[["==", "attr1", "val1"],["==", "attr2", "val2"]]]
    end

    it "allows filtering by attribute with not-equal comparison" do
      described_class.from_string("[attr1!=val1,attr2!=val2]").keys.should == [[["!=", "attr1", "val1"],["!=", "attr2", "val2"]]]
    end

    it "allows empty array" do
      described_class.from_string("[]").keys.should == [[]]
    end

    it "returns array filter with the whole value for unknown or missing operator" do
      described_class.from_string("[attr1,attr2~val2]").keys.should == [[["attr1"], ["attr2~val2"]]]
    end

    it "combines hash and array filtering" do
      described_class.from_string("foo.[attr==val,attr!=val1]").keys.should == ["foo", [["==", "attr", "val"],["!=", "attr", "val1"]]]
      described_class.from_string("[attr==val,attr!=val1].bar").keys.should == [[["==", "attr", "val"],["!=", "attr", "val1"]], "bar"]
    end
  end
end
