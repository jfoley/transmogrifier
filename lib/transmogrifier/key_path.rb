module Transmogrifier
  class KeyPath
    def initialize(hash)
      @hash = hash
    end

    def find(path)
      matches = find_hash_with_parent(path)

      #puts "parent: ", parent.inspect
      #puts "child: ", child.inspect
      #puts "key:, ", key.inspect

      matches.map(&:child)
    end

    def modify(path, &blk)
      matches = find_hash_with_parent(path)
      match = matches[0]
      parent, child, key = match.parent, match.child, match.key
      if parent.nil?
        blk.call(child)
      else
        parent[key] = blk.call(child)
      end
    end

    private

    def find_hash_with_parent(path)
      puts "path: ", path.inspect
      #if path.match(/^\./) # starts_with .
      #  keys = path.split(".")
      #  matches = find_from_root_sub_hash(@hash, keys, [])
      #else
      #  keys = path.split(".")
      #  matches = find_sub_hash(@hash, keys, [])
      #end

      keys = path.split(".")
      matches = []
      start(@hash, keys, matches)

      matches
    end

    def find_sub_hash(hash, keys, matches)
      wip(nil, hash, keys, matches)
      matches
    end

    def start(hash, keys, matches)
      root_match_only = false
      if keys[0] == ""
        root_match_only = true
        keys.shift
      end
      wip(nil, hash, keys, matches, root_match_only)
    end

    def wip(parent, hash, keys, matches, root_match_only)
      puts "parent: #{parent.inspect}, hash: #{hash.inspect}, keys: #{keys.inspect}"
      hash.each do |key, value|
        puts "key: #{key.inspect}, value: #{value.inspect}"
        if key == keys[0]
          # possible match, keep going
          if ( keys.length == 1 )
            # its a match
            matches << Match.new(parent, hash, key)
          else
            keys.shift
            wip(hash, value, keys, matches, root_match_only) if value.is_a?(Hash)
          end
        else
          next if root_match_only
          # go deeper
          wip(hash, value, keys, matches, root_match_only) if value.is_a?(Hash)
        end
      end
    end

    def find_from_sub_hash(hash, keys, matches)
      # find the first "key" match.  recurse on each

      puts "hash: ", hash.inspect
      puts "keys: ", keys.inspect
      current = hash
      key = keys.shift
      puts "current key: #{key}"
      parent = current
      current = current[key]



    end

    def find_from_root_sub_hash(hash, keys, matches)
      keys.reject! { |k| k.nil? || k.empty? }
      puts "hash: ", hash.inspect
      puts "keys: ", keys.inspect
      current = hash
      key = keys.shift
      puts "current key: #{key}"
      parent = current
      current = current[key]


      if keys.length == 1
        if ( current.has_key?(keys[0]))
          matches << Match.new(parent, current, key) unless current.nil?
        end
      else
        return [] if current.nil?
        current.each do |k, sub_hash|
          find_sub_hash(sub_hash, keys, matches)
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