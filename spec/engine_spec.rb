require "transmogrifier"

describe Transmogrifier::Engine do
  subject(:engine) { described_class.from_rules_array(rules) }

  describe "#run" do
    let(:rules) do
      [
        {
          "type" => "append",
          "selector" => "top",
          "object" => {"some" => "attributes"}
        },

        {
          "type" => "move",
          "selector" => "top",
          "from" => "key1",
          "to" => "key2",
        },

        {
          "type" => "delete",
          "selector" => "top",
          "name" => "key3"
        }
      ]
    end

    it "runs all the rules" do
      input_hash = {
        "top" => {
          "key1" => "value1",
          "key3" => "value2"
        }
      }
  
      expect(engine.run(input_hash)).to eq({
        "top" => {
          "some" => "attributes",
          "key2" => "value1",
        }
      })
    end
  end
end
