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
      described_class.from_string("[attr1=val1,attr2=val2]").keys.should == [[["attr1", "val1"],["attr2", "val2"]]]
    end

    it "allows empty array" do
      described_class.from_string("[]").keys.should == [[]]
    end

    it "combines hash and array filtering" do
      described_class.from_string("foo.[attr=val]").keys.should == ["foo", [["attr", "val"]]]
    end
  end
end
