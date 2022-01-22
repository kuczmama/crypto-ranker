require 'json'
require_relative '../db'
require_relative 'load_coin_marketcap_data'

class ThirdPartyDataLoadingService    
    class << self
        def load_coin_marketcap_data_from_file
            puts "Loading coin marketcap data from file..."
            raw_file = File.read('data/coins/coin-marketcap-data.json')
            JSON.parse(raw_file)["data"].each do |coin|
                Db::coins.insert({
                    coin_marketcap_id: coin['id'].to_i,
                    name: coin['name'],
                    symbol: coin['symbol'],
                    slug: coin['slug']})
            end
        end

        def load_coin_marketcap_metadata_from_file
            puts "Loading coin marketcap metadata from file..."
            Dir['data/metadata/*'].each do |fname|
                puts "Loading #{fname}"
                raw_file = File.read(fname)
                data = JSON.parse(raw_file)["data"]
                if data.nil?
                    puts "No data in #{fname}"
                    next
                end
                data.each do |coin_marketcap_id, coin|
                    source_code = coin['urls']['source_code'].nil? ? '' : coin['urls']['source_code'].first
                    puts "source_code: #{source_code}"
                    Db::coins
                            .where(coin_marketcap_id: coin_marketcap_id)
                            .update(source_code_url: source_code || "")
                end
            end
        end

        def load_coin_marketcap_data_from_api
            puts "Loading coin marketcap data from API..."
            data = LoadCoinMarketcapData.load_coin_marketcap_data
            data.each do |coin|
                Db::coins.insert({
                    coin_marketcap_id: coin['id'].to_i,
                    name: coin['name'],
                    symbol: coin['symbol'],
                    slug: coin['slug']})
            end
        end
    end
end
