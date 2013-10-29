module Transmogrifier
  class KeyPath
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def find(path)
      find_matches(path)
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

    class Key
      def initialize(obj)
        @obj = obj
      end

      def selector?
        @obj.is_a?(String)
      end

      def query?
        @obj.is_a?(Hash)
      end

      def to_s
        if selector?
          @obj
        else
          "[#{@obj[:key]}=#{@obj[:value]}]"
        end
      end

      def key
        @obj[:key]
      end

      def value
        @obj[:value]
      end
    end

    class Selector
      def initialize(string)
        @keys = string.split(".").select { |x| x != "" }.map do |str|
          matches = str.scan(/\[(.*)=(.*)\]/).flatten
          if matches.any?
            Key.new({
              key: matches[0],
              value: matches[1],
            })
          else
            Key.new(str)
          end
        end
      end

      def keys
        @keys
      end
    end

    def find_matches(path)
      matches = []

      if path == "."
        matches << Match.new(nil, nil, @hash)
        return matches
      end

      selector = Selector.new(path)
      keys = selector.keys

      # Root matching is a special case where we deal with a path that starts with a "."
      #root_matching = keys[0] == ""
      #root_has_first_key = @hash.has_key?(keys[1])
      #if root_matching
      #  if root_has_first_key
      #    keys.shift
      #  else
      #    return []
      #  end
      #end

      idx = 0

      parent = nil
      current = @hash

      puts keys.inspect
      while keys.any? && !current.nil?
        key = keys.shift

        if key.selector?
          parent = current
          current = current[key.to_s]
        elsif key.query?
          puts "current"
          puts current.inspect
          current = current.detect { |x| x[key.key] == key.value }
        end
      end

      p parent
      p key
      p current
      matches << Match.new(parent, key.to_s, current)



      #traverse(@hash, nil) do |parent, key, value|
      #  #p parent
      #  #p key
      #  #p value
      #
      #  if keys[idx].is_a?(String)
      #    idx += 1 if keys[idx] == key
      #  elsif keys[idx].is_a?(Hash)
      #    if keys[idx][:key] == key && keys[idx][:value] == value
      #      matches << Match.new(parent, key, value)
      #      idx += 1
      #    end
      #
      #    p parent
      #    p value
      #
      #    #idx += 1 if keys[idx][:key] == key
      #  end
      #
      #  if keys.length == idx
      #    matches << Match.new(parent, key, value)
      #    idx = 0
      #  end
      #end

      matches
    end

    def traverse(obj, parent, &blk)
      case obj
        when Hash
          obj.each do |k, v|
            blk.call(obj, k, v)
            # Pass hash key as parent
            traverse(v, obj, &blk)
          end
        when Array
          obj.each {|v| traverse(v, parent, &blk) }
        else
          blk.call(parent, nil, nil)
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
    attr_accessor :parent, :key, :value
    def initialize(parent, key, value)
      raise ArgumentError if parent.nil? && !key.nil?
      raise ArgumentError if !parent.nil? && (key.nil? || value.nil?)
      @parent, @key, @value = parent, key, value
    end

    def ==(rhs)
      parent == rhs.parent &&
      key == rhs.key &&
      value == rhs.value
    end
    alias :eql? :==
  end
end

