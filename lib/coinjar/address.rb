module CoinJar
  class Address

    class << self

      def generate(label = nil)
        response = CoinJar.client.post("bitcoin_addresses", "label=#{label}")
        self.new(response[:bitcoin_address])
      end

      def list(offset = 0, limit = 100)
        response = CoinJar.client.get('bitcoin_addresses', {offset: offset, limit: limit})
        response[:bitcoin_addresses].map{|bitcoin_address| self.new(bitcoin_address)}
      end

    end # class << self

    attr_accessor\
      :address,
      :label

    def initialize(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end
