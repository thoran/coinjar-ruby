module CoinJar
  class Transaction

    class << self

      def all
        offset = -100
        all_transactions = []
        query_results = [nil]
        until query_results.empty?
          query_results = self.list(offset += 100)
          all_transactions += query_results
        end
        all_transactions
      end

      def bitcoin_transactions
        all.select{|t| t.bitcoin_transaction?}
      end

      def exchange_transactions
        all.select{|t| t.exchange_transaction?}
      end

      def bitcoin_deposits
        all.select{|t| t.bitcoin_deposit?}
      end
      alias_method :btc_received, :bitcoin_deposits

      def bitcoin_withdrawals
        all.select{|t| t.bitcoin_withdrawal?}
      end
      alias_method :btc_sent, :bitcoin_withdrawals

      def purchases
        all.select{|t| t.purchase?}
      end
      alias_method :btc_bought, :purchases

      def sales
        all.select{|t| t.sale?}
      end
      alias_method :btc_sold, :sales

      def find_by_bitcoin_txid(txid)
        all.detect{|t| txid == t.bitcoin_txid}
      end

      def find_all_by_bitcoin_txid(*txids)
        txids = txids.flatten
        all.select{|t| txids.include?(t.bitcoin_txid)}
      end

      def find(uuid)
        transaction = self.new(uuid: uuid)
        transaction.fetch
        transaction
      end

      def list(offset = 0, limit = 100)
        response = CoinJar.client.get('transactions', {offset: offset, limit: limit})
        response[:transactions].map{|transaction| self.new transaction}
      end

    end # class << self

    attr_accessor\
      :amount,
      :bitcoin_txid,
      :confirmations,
      :counterparty_name,
      :counterparty_type,
      :created_at,
      :status,
      :related_payment_uuid,
      :updated_at,
      :uuid

    def initialize(args)
      reset(args)
    end

    def fetch
      response = CoinJar.client.get('transactions/' + uuid)
      self.reset(response[:transaction])
      self
    end

    def reset(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    # boolean methods

    def bitcoin_transaction?
      bitcoin_txid
    end

    def exchange_transaction?
      bitcoin_txid.nil?
    end

    def deposit?
      amount.to_f > 0
    end

    def withdrawal?
      amount.to_f < 0
    end

    def bitcoin_deposit?
      bitcoin_transaction? && deposit?
    end

    def bitcoin_withdrawal?
      bitcoin_transaction? && withdrawal?
    end

    def purchase?
      exchange_transaction? && deposit? # Effectively a deposit of bitcoin from fiat.
    end

    def sale?
      exchange_transaction? && withdrawal? # Effectively a withdrawal of bitcoin to fiat.
    end

  end
end
