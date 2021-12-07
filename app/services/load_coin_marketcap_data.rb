# Load coin marketcap data

require 'net/http'
require 'json'
require 'date'

class LoadCoinMarketcapData
    class << self
        @@base_url = "https://pro-api.coinmarketcap.com/v1" #cryptocurrency/map?CMC_PRO_API_KEY=0b4c914d-7e3c-4ba7-a86b-277782859ce1
        @@api_key = ENV['CMC_PRO_API_KEY']

        # /v1/cryptocurrency/map - Load list of cryptocurrencies
        # https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyMap
        def all_cryptocurrencies
            request("/cryptocurrency/map?CMC_PRO_API_KEY=#{@@api_key}")
        end

        def metadata(ids)
            # https://pro-api.coinmarketcap.com/v1/cryptocurrency/info
            url = "/cryptocurrency/info?id=#{ids.join(',')}&CMC_PRO_API_KEY=#{@@api_key}"
            request(url)
        end

        private
        def request(url)
            uri = URI.parse("#{@@base_url}#{url}")
            puts uri
            Net::HTTP.get(uri)
        end
    end
end

puts LoadCoinMarketcapData.all_cryptocurrencies
puts LoadCoinMarketcapData.metadata([15682])