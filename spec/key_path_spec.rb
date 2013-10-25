require "transmogrifier"

describe Transmogrifier::KeyPath do
  describe "#find" do
    it "returns the hash if the path is just a dot" do
      input_hash = {"top_level" => "value" }

      expect(Transmogrifier::KeyPath.new(input_hash).find(".")).to eq([{"top_level" => "value"}])
    end

    it "takes a path of hash keys with dots between" do
      input_hash = {"top_level" => { "nested" => "value" }}

      expect(Transmogrifier::KeyPath.new(input_hash).find("top_level.nested")).to eq([{"nested" => "value"}])
    end

    it "uses a dot at the front to mean an absolute path in the hash" do
      input_hash = {"top_level" => { "nested" => "value" }}

      expect(Transmogrifier::KeyPath.new(input_hash).find(".top_level.nested")).to eq([{"nested" => "value"}])
    end

    it "returns only the specified element" do
      input_hash = {
        "top_level" => {
          "nested" => "value",
        },
        "another_top_level" => {
          "nested" => "another_value",
        },
      }

      expect(Transmogrifier::KeyPath.new(input_hash).find(".top_level.nested")).to eq([{"nested" => "value"}])
    end

    it "matches nested elements if no absolute path is given" do
      input_hash = {
        "top_level" => {
          "nested" => "value",
        },
        "another_top_level" => {
          "nested" => "another_value",
        },
      }

      expected_output = [{"nested" => "value"}, {"nested" => "another_value"}]
      expect(Transmogrifier::KeyPath.new(input_hash).find("nested")).to eq(expected_output)
    end
  end

  describe "#modify" do
    context "when the key is top level" do
      it "calls the block on the top level hash" do
        input_hash = {"top_level" => { "nested" => "value" }}
        blk = ->(hash){ hash["top_level"] = "new_value"; hash }

        Transmogrifier::KeyPath.new(input_hash).modify(".top_level", &blk)
        expect(input_hash).to eq({"top_level" => "new_value"})
      end
    end

    context "when the key is nested" do
      it "finds a hash and then calls the block on it" do
        input_hash = {"top_level" => { "nested" => "value" }}
        blk = ->(hash){ hash["nested"] = "new_value"; hash }

        Transmogrifier::KeyPath.new(input_hash).modify(".top_level.nested", &blk)
        expect(input_hash).to eq({"top_level" => { "nested" => "new_value" }})
      end
    end
  end
end
