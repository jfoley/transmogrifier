require_relative "node"

module Transmogrifier
  class HashNode < Node
    extend Forwardable

    def initialize(hash)
      @hash = hash
    end

    def find_all(keys)
      first_key, *remaining_keys = keys

      if first_key.nil?
        [self]
      elsif child = @hash[first_key]
        Node.for(child).find_all(remaining_keys)
      else
        []
      end
    end

    def_delegator :@hash, :delete
    def_delegator :@hash, :merge!, :append
    def_delegator :@hash, :to_hash, :raw
  end
end