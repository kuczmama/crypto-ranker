# This file sets up the database from the files

require(File.expand_path('app/services/third_party_data_loading_service.rb', File.dirname(__FILE__)))

ThirdPartyDataLoadingService.load_coin_marketcap_metadata_from_file