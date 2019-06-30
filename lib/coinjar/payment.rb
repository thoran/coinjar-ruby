module CoinJar
  class Payment

    class << self

      def find(uuid)
        payment = self.new(uuid: uuid)
        payment.fetch
        payment
      end

      def list(offset = 0, limit = 100)
        response = CoinJar.client.get('payments', {offset: offset, limit: limit})
        response[:payments].map{|payment| self.new(payment)}
      end

    end # class << self

    attr_accessor\
      :amount,
      :created_at,
      :payee,
      :payee_name,
      :related_transaction_uuid,
      :status,
      :updated_at,
      :uuid

    def initialize(**args)
      reset(**args)
    end

    def create
      response = CoinJar.client.post('payments', {payment: self.instance_values})
      self.reset(response[:payment])
      self
    end

    def confirm!
      response = CoinJar.client.post("payments/#{uuid}/confirm", nil)
      self.reset(response[:payment])
      self
    end

    def fetch
      response = CoinJar.client.get("payments/#{uuid}")
      self.reset(response[:payment])
      self
    end

    def reset(**args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end
