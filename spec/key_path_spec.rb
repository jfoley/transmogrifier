require "transmogrifier"

describe Transmogrifier::KeyPath do
  #describe "#build_hash" do
  #  it "works" do
  #    Transmogrifier::KeyPath.new({}).build_hash(input = {}, ["first", "second"])
  #    input.should == {"first"=>{"second"=>{}}}
  #  end
  #end

  describe "#find" do
    it "returns the hash if the path is just a dot" do
      input_hash = {"top_level" => "value" }
      match = Transmogrifier::Match.new(nil, nil, {"top_level" => "value" })

      expect(Transmogrifier::KeyPath.new(input_hash).find(".")).to eq([match])
    end

    it "takes a path of hash keys with dots between" do
      input_hash = {"top_level" => { "nested" => "value" }}
      match = Transmogrifier::Match.new(
        { "nested" => "value" },
        "nested",
        "value",
      )

      expect(Transmogrifier::KeyPath.new(input_hash).find("top_level.nested")).to eq([match])
    end

    it "uses a dot at the front to mean an absolute path in the hash" do
      input_hash = {"top_level" => { "nested" => "value" }}
      match = Transmogrifier::Match.new(
        { "nested" => "value" },
        "nested",
        "value",
      )

      expect(Transmogrifier::KeyPath.new(input_hash).find(".top_level.nested")).to eq([match])
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
      match = Transmogrifier::Match.new(
        { "nested" => "value" },
        "nested",
        "value",
      )

      expect(Transmogrifier::KeyPath.new(input_hash).find(".top_level.nested")).to eq([match])
    end

    it "matches nested elements if no absolute path is given" do
      input_hash = {
        "top_level" => {
          "nested" => "value",
        },
        "another_top_level" => {
          "nested" => "another_value",
        },
        "last_top_level" => {
          "middle_level" => {
            "nested" => "deep_value"
          }
        }
      }
      matches = [
        Transmogrifier::Match.new(
          { "nested" => "value" },
          "nested",
          "value",
        ),
        Transmogrifier::Match.new(
          { "nested" => "another_value" },
          "nested",
          "another_value",
        ),
        Transmogrifier::Match.new(
          { "nested" => "deep_value" },
          "nested",
          "deep_value",
        ),
      ]

      expect(Transmogrifier::KeyPath.new(input_hash).find("nested")).to eq(matches)
    end

    it "matches array elements" do
      input_hash = {
        "top_level" => [{
          "name" => "array_element",
        }],
      }

      match = Transmogrifier::Match.new(
        {"name" => "array_element"},
        "name",
        "array_element",
      )

      expect(Transmogrifier::KeyPath.new(input_hash).find("array_element")).to eq([match])
    end
  end

  describe "#modify" do
    context "when the key is top level" do
      it "calls the block on the top level hash" do
        input_hash = {"top_level" => { "nested" => "value" }}
        blk = ->(match){ match.parent[match.key] = "new_value" }

        Transmogrifier::KeyPath.new(input_hash).modify(".top_level", &blk)
        expect(input_hash).to eq({"top_level" => "new_value"})
      end
    end

    context "when the key is nested" do
      it "finds a hash and then calls the block on it" do
        input_hash = {"top_level" => { "nested" => "value" }}
        blk = ->(match){ match.parent[match.key] = "new_value" }

        Transmogrifier::KeyPath.new(input_hash).modify(".top_level.nested", &blk)
        expect(input_hash).to eq({"top_level" => { "nested" => "new_value" }})
      end
    end
  end
end
