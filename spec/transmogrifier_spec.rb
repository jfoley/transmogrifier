require "transmogrifier"

describe Transmogrifier::Engine do
  subject(:engine) { described_class.from_rules_array(rules) }

  describe "#run" do
    context "when there are multiple rules" do
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

      it "runs them all" do
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

    context "when there is a single rule" do
      describe "appending keys" do
        let(:input_hash) do
          { "key" => "value", "array" => [] }
        end

        context "when the selector finds a HashNode" do
          let(:rules) { [ {"type" => "append", "selector" => "", "object" => {"new_key" => "new_value"}} ] }

          it "appends to the hash" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "array" => [],
              "new_key" => "new_value",
            })
          end
        end

        context "when the selector finds an ArrayNode" do
          let(:rules) { [ {"type" => "append", "selector" => "array", "object" => {"new_key" => "new_value"}} ] }

          it "appends to the array" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "array" => [{"new_key" => "new_value"}],
            })
          end
        end
      end

      describe "deleting keys" do
        let(:input_hash) do
          {
            "key" => "value",
            "array" => [{"inside" => "value"}],
            "nested" => {
              "key" => "value"
            },
          }
        end 

        context "when the selector finds a HashNode" do
          let(:rules) { [ {"type" => "delete", "selector" => "", "name" => "nested"} ] }

          it "deletes the hash from the parent" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "array" => [{"inside" => "value"}],
            })
          end
        end

        context "when the selector finds an ArrayNode" do
          let(:rules) { [ {"type" => "delete", "selector" => "array", "name" => "[inside=value]"} ] }
          
          it "deletes the array from the parent" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "array" => [],
              "nested" => {
                "key" => "value"
              },
            })
          end
        end
      end

      describe "moving keys" do
        let(:input_hash) do
          {
            "key" => "value",
            "array" => [{"inside" => "value"}],
            "nested" => {
              "key" => "value",
            },
          }
        end

        context "when the selector finds a HashNode" do
          context "when the target key exists" do
            let(:rules) { [ {"type" => "move", "selector" => "", "from" => "array.[inside=value]", "to" => "nested"}]}
            
            it "moves the hash to the to selector" do
              expect(engine.run(input_hash)).to eq({
                "key" => "value",
                "array" => [],
                "nested" => {
                  "key" => "value",
                  "inside" => "value",
                },
              })
            end
          end

          context "when the target key doesn't exist" do
            let(:rules) { [ {"type" => "move", "selector" => "", "from" => "array.[inside=value]", "to" => "nested.nested_again"} ] }
            
            it "moves the hash to a new child" do
              expect(engine.run(input_hash)).to eq({
                "key" => "value",
                "array" => [],
                "nested" => {
                  "key" => "value",
                  "nested_again" => {
                    "inside" => "value",
                  }
                },
              })
            end
          end

          context "when the from selector has a wildcard" do
            let(:input_hash) do
              {
                "list_of_things" => [
                  {
                    "name" => "object1",
                    "property" => "property1",
                    "nested" => {}
                  },
                  {
                    "name" => "object2",
                    "property" => "property2",
                    "nested" => {}
                  },
                ]
              }
            end
            let(:rules) { [ {"type" => "move", "selector" => "list_of_things.[]", "from" => "property", "to" => "nested.property"} ] }

            it "moves the matched hash to the correct place" do
              expect(engine.run(input_hash)).to eq({
                "list_of_things" => [
                  {
                    "name" => "object1",
                    "nested" => { "property" => "property1" }
                  },
                  {
                    "name" => "object2",
                    "nested" => { "property" => "property2" }
                  },
                ]
              })
            end
          end
        end

        context "when the selector finds an ArrayNode" do
          let(:rules) { [ {"type" => "move", "selector" => "", "from" => "array", "to" => "nested.array"} ] }
          
          it "moves the array to the to selector" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "nested" => {
                "key" => "value",
                "array" => [{"inside" => "value"}],
              },
            })
          end
        end

        context "using move as a rename" do
          let(:rules) { [ {"type" => "move", "selector" => "", "from" => "array", "to" => "new_array"} ] }
          
          it "renames the node" do
            expect(engine.run(input_hash)).to eq({
              "key" => "value",
              "new_array" => [{"inside" => "value"}],
              "nested" => {
                "key" => "value",
              },
            })
          end
        end
      end
    end
  end
end
