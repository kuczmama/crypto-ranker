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
            request("/cryptocurrency/map?CMC_PRO_API_KEY=#{@@api_key}")
        end

        def metadata(ids)
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
                sleep(60)
                idx += 1
            end
        end

        private
        def request(url)
            uri = URI.parse("#{@@base_url}#{url}")
            puts uri
            Net::HTTP.get(uri)
        end
    end
end

# puts LoadCoinMarketcapData.all_cryptocurrencies
# LoadCoinMarketcapData.load_all_metadata
pages_to_load = [6, 28, 61]
pages_to_load.each do |idx|
    ids = Db::coins.all.pluck(:coin_marketcap_id).each_slice(100).to_a[idx]
    data = LoadCoinMarketcapData.metadata(ids)
    File.write("#{Dir.pwd}/data/coin_marketcap_metadata#{idx}.json", data.to_s)
    sleep(20)
end