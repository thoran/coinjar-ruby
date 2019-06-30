module CoinJar
  class Account

    class << self

      def find
        user = self.new
        user.fetch
        user
      end

    end # class << self

    attr_accessor\
      :available_balance,
      :email,
      :full_name,
      :unconfirmed_balance,
      :uuid,

    def initialize; end

    def fetch
      response = CoinJar.client.get('account')
      self.reset(response[:user])
      self
    end

    def reset(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end
