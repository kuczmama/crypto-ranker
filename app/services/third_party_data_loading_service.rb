require 'json'
require_relative '../db'
require_relative 'load_coin_marketcap_data'

class ThirdPartyDataLoadingService    
    class << self
        def load_coin_marketcap_data_from_file
            raw_file = File.read('../../data/coin-marketcap-data.json')
            JSON.parse(raw_file)["data"].each do |coin|
                Db::coins.insert({
                    coin_marketcap_id: coin['id'].to_i,
                    name: coin['name'],
                    symbol: coin['symbol'],
                    slug: coin['slug']})
            end
        end

        def load_coin_marketcap_data_from_api
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


ThirdPartyDataLoadingService.load_coin_marketcap_data_from_file