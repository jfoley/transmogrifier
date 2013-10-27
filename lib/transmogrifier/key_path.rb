module Transmogrifier
  class KeyPath
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def find(path)
      matches = find_matches(path)

      matches.map(&:slice)
    end

    def modify(path, &blk)
      matches = find_matches(path)
      matches.each do |match|
        blk.call(match)
      end
    end

    def mkdir(path)
      keys = path.split(".")
      root_matching = keys[0] == ""
      return if !root_matching # TODO: this should probably be a raise?

      keys.shift

      output_hash = @hash.dup
      build_hash(output_hash, keys)
      @hash = output_hash
    end

    private

    def find_matches(path)
      matches = []

      if path == "."
        matches << Match.new(nil, nil, @hash, @hash)
        return matches
      end

      keys = path.split(".")

      # Root matching is a special case where we deal with a path that starts with a "."
      root_matching = keys[0] == ""
      root_has_first_key = @hash.has_key?(keys[1])
      if root_matching
        if root_has_first_key
          keys.shift
        else
          return []
        end
      end

      idx = 0
      traverse(@hash, nil) do |key, value, parent, slice|
        if keys[idx] == key
          idx += 1
        end

        if keys.length == idx
          matches << Match.new(parent, key, value, slice)
          idx = 0
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

    def build_hash(input_hash, keys)
      return input_hash if keys.empty?

      key = keys.shift
      if input_hash.has_key?(key)
        if !input_hash[key].is_a?(Array)
          build_hash(input_hash[key], keys)
        end
      else
        input_hash[key] = {}
        build_hash(input_hash[key], keys)
      end
    end
  end

  class Match
    attr_accessor :parent, :key, :value, :slice
    def initialize(parent, key, value, slice)
      @parent, @key, @value, @slice = parent, key, value, slice
    end

    def ==(rhs)
      parent == rhs.parent &&
      key == rhs.key &&
      value == rhs.value &&
      slice == rhs.slice
    end
    alias :eql? :==
  end
end

