# This service loads all of the data from a third party source, and insert the data
# And updates the database# This file sets up the database from the files

require(File.expand_path('third_party_data_loading_service.rb', File.dirname(__FILE__)))
require(File.expand_path('data_ranker.rb', File.dirname(__FILE__)))
require(File.expand_path('runner_service.rb', File.dirname(__FILE__)))

FILE_NAME = "load_all_data"
MINUTES_PER_DAY = 60 * 24

RunnerService.process(FILE_NAME, MINUTES_PER_DAY) do
    # # # # Load all of the coins from coinmarketcap, via the file saved
    puts "Loading coins from coinmarketcap"
    ThirdPartyDataLoadingService.load_coin_marketcap_coin_data_from_api
    puts "Loading coin metadata from coinmarketcap"
    ThirdPartyDataLoadingService.load_coin_marketcap_metadata_from_api

    puts "Loading all github metadata"
    ThirdPartyDataLoadingService.load_all_github_metadata(reload_data: true)

    # # Calculate the data ranks
    puts "Calculating data ranks"
    count = Db::github_metadata.count
    Db::github_metadata.all.each_with_index do |github_metadata, idx|
        puts "#{idx}/#{count}"
        DataRanker.calculate_rank_score(github_metadata)
    end
    DataRanker.calculate_ranks
end