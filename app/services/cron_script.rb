# This service loads all of the data from a third party source, and insert the data
# And updates the database# This file sets up the database from the files

require(File.expand_path('third_party_data_loading_service.rb', File.dirname(__FILE__)))
require(File.expand_path('data_ranker.rb', File.dirname(__FILE__)))
require(File.expand_path('runner_service.rb', File.dirname(__FILE__)))


MINUTES_PER_DAY = 60 * 24

RunnerService.process("coin_marketcap_coin_data", MINUTES_PER_DAY) do
    # # # # Load all of the coins from coinmarketcap, via the file saved
    puts "Loading coins from coinmarketcap"
    ThirdPartyDataLoadingService.load_coin_marketcap_coin_data_from_api
end

RunnerService.process("coin_marketcap_metadata", MINUTES_PER_DAY) do
    puts "Loading coin metadata from coinmarketcap"
    ThirdPartyDataLoadingService.load_coin_marketcap_metadata_from_api
end

RunnerService.process("github_metadata", MINUTES_PER_DAY) do
    puts "Loading all github metadata"
    ThirdPartyDataLoadingService.load_all_github_metadata(reload_data: true)
end

RunnerService.process("calculate_ranks", MINUTES_PER_DAY) do
    # # Calculate the data ranks
    puts "Calculating data ranks"
    DataRanker.calculate_ranks
end

RunnerService.process("delete_duplicate_github_urls", MINUTES_PER_DAY) do
    Db::coins
            .select(:github_url)
            .having(Arel.star.count.gt(1))
            .group(:github_url).each do |coin|
        next if coin.github_url.nil? || coin.github_url.empty?
        
        duplicate_coins = Db::coins.where(github_url: coin.github_url)
        min_coin_marketcap_id = duplicate_coins.pluck(:coin_marketcap_id).min
        puts "min_coin_marketcap_id: #{min_coin_marketcap_id}"
        # puts duplicate_coins.count
        duplicate_coins.where("coin_marketcap_id > ? ", min_coin_marketcap_id).each do |duplicate_coin|
            # puts duplicate_coin.inspect
            puts "Deleting #{duplicate_coin.inspect}..."
            Db::github_metadata.where(coin_id: duplicate_coin.id).delete_all
            duplicate_coin.delete
        end
    end
end