# This file sets up the database from the files

require(File.expand_path('app/services/third_party_data_loading_service.rb', File.dirname(__FILE__)))

# # # # Load all of the coins from coinmarketcap, via the file saved
# ThirdPartyDataLoadingService.load_coin_marketcap_data_from_file

# # # # # Load all metadata from coinmarketcap, via the file saved
# ThirdPartyDataLoadingService.load_coin_marketcap_metadata_from_file

# # Save the github metadata to the database

ThirdPartyDataLoadingService.load_github_metadata_from_file
# ThirdPartyDataLoadingService.load_all_github_metadata(reload_data: false)