# Load coin marketcap data

require 'net/http'
require 'json'
require 'date'
require_relative '../db'

class LoadCoinMarketcapData
    class << self
        @@base_url = "https://pro-api.coinmarketcap.com/v1"
        @@api_key = ENV['CMC_PRO_API_KEY']

        # /v1/cryptocurrency/map - Load list of cryptocurrencies
        # https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyMap
        def all_cryptocurrencies
            has_cmc_api_key?

            request("/cryptocurrency/map?CMC_PRO_API_KEY=#{@@api_key}")
        end

        def load_all_cryptocurrencies
            puts "Loading all cryptocurrencies..."
            data = all_cryptocurrencies || []
            File.write("#{Dir.pwd}/data/coins/coin-marketcap-data.json", data.to_s)
            JSON.parse(data)["data"]
        end

        def metadata(ids)
            has_cmc_api_key?

            # https://pro-api.coinmarketcap.com/v1/cryptocurrency/info
            url = "/cryptocurrency/info?id=#{ids.join(',')}&CMC_PRO_API_KEY=#{@@api_key}"
            request(url)
        end

        ## Load all metadata... you can load upto max 100 ids at a time
        def load_all_metadata
            idx = 0
            Db::coins.all.pluck(:coin_marketcap_id).each_slice(100) do |ids|
                data = metadata(ids)
                File.write("#{Dir.pwd}/data/coin_marketcap_metadata#{idx}.json", data.to_s)
                sleep(5)
                idx += 1
            end
        end

        private

        def has_cmc_api_key?
            if @@api_key.nil?
                raise "Must set Coin market cap API environment variable: CMC_PRO_API_KEY https://pro.coinmarketcap.com/api/v1#"
            end
            !@@api_key.nil?
        end

        def request(url)
            uri = URI.parse("#{@@base_url}#{url}")
            puts uri
            Net::HTTP.get(uri)
        end
    end
end

# puts LoadCoinMarketcapData.all_cryptocurrencies
# LoadCoinMarketcapData.load_all_metadata