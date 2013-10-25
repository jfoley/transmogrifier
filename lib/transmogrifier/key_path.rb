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
      keys = path.split(".")
      matches = []

      root_match_only = false
      if keys[0] == ""
        root_match_only = true
        keys.shift
      end
      find_sub_hashes(nil, @hash, keys, matches, root_match_only)

      matches
    end

    def find_sub_hashes(parent, hash, keys, matches, root_match_only)
      hash.each do |key, value|
        if key == keys[0]
          # possible match, keep going
          if ( keys.length == 1 )
            # its a match
            matches << Match.new(parent, hash, key)
          else
            keys.shift
            find_sub_hashes(hash, value, keys, matches, root_match_only) if value.is_a?(Hash)
          end
        else
          next if root_match_only
          # go deeper
          find_sub_hashes(hash, value, keys, matches, root_match_only) if value.is_a?(Hash)
        end
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