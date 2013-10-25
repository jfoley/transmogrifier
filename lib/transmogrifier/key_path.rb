module Transmogrifier
  class KeyPath
    def initialize(hash)
      @hash = hash
    end

    def find(path)
      matches = find_matches(path)

      matches.map(&:child)
    end

    def modify(path, &blk)
      matches = find_matches(path)
      matches.each do |match|
        blk.call(match.child)
      end
    end

    private

    def find_matches(path)
      matches = []

      if path == "."
        matches << Match.new(nil, @hash, nil)
        return matches
      end

      keys = path.split(".")

      idx = 0
      root_matching = keys[0] == ""

      traverse(@hash, nil) do |key, value, parent, slice|
        if root_matching
          idx += 1
          if keys[idx] == key && idx == keys.length - 1
            matches << Match.new(parent, slice, key)
          end
        else
          if keys[idx] == key
            idx += 1
          end

          if keys.length == idx
            matches << Match.new(parent, slice, key)
            idx = 0
          end
        end

      end

      matches
    end

    def traverse(obj, parent, &blk)
      case obj
        when Hash
          obj.each do |k, v|
            blk.call(k, v, parent, obj)
            # Pass hash key as parent
            traverse(v, k, &blk)
          end
        when Array
          obj.each {|v| traverse(v, parent, &blk) }
        else
          blk.call(nil, nil, parent, obj)
      end
    end

    class Match
      attr_accessor :parent, :child, :key
      def initialize(parent, child, key)
        @parent, @child, @key = parent, child, key
      end
    end
  end
end

