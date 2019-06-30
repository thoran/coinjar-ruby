module CoinJar
  module Configuration
    VALID_CONFIG_KEYS = [:api_key, :endpoint, :format]

    DEFAULT_ENDPOINT = 'https://api.coinjar.io/v1'
    DEFAULT_API_KEY = nil
    DEFAULT_FORMAT = :json

    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def reset
      @endpoint = DEFAULT_ENDPOINT
      @api_key = DEFAULT_API_KEY
      @format = DEFAULT_FORMAT
    end

    def config_options
      Hash[*VALID_CONFIG_KEYS.map{|key| [key, send(key)]}.flatten]
    end

  end
end
