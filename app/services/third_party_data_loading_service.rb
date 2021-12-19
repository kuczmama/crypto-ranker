require 'json'
require_relative '../db'

class ThirdPartyDataLoadingService    
    class << self
        def load_coin_marketcap_data_from_file
            raw_file = File.read('../../data/coin-marketcap-data.json')
            JSON.parse(raw_file)["data"].each do |coin|
                Db::coins.insert({
                    coin_marketcap_id: coin['id'].to_i,
                    name: coin['name'],
                    symbol: coin['symbol'],
                    slug: coin['slug'],
                    rank: 0})
            end
        end
    end
end

ThirdPartyDataLoadingService.load_coin_marketcap_data_from_file