require 'json'
require_relative '../db'
require_relative '../helpers/github_helper'
require_relative 'load_coin_marketcap_data'
require_relative 'load_github_data'
require 'byebug'

# This is a kludgy file to load all of the data from a third party source, and insert the data
# into the database.
class ThirdPartyDataLoadingService    
    class << self

        # Load the coin marketcap coin data from the file
        def load_coin_marketcap_coin_data_from_file
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
        # Load all of the coin marketcap data via the api
        def load_coin_marketcap_metadata_from_file
            puts "Loading coin marketcap metadata from file..."
            Dir['data/coinmarketcap-metadata/*'].each do |fname|
                puts "Loading #{fname}"
                raw_file = File.read(fname)
                data = JSON.parse(raw_file)["data"]
                if data.nil?
                    puts "No data in #{fname}"
                    next
                end
                idx = 0
                len = data.length
                data.each do |coin_marketcap_id, coin|
                    puts "#{idx}/#{len}: Loading coin market cap metadata #{coin}"
                    coin_marketcap_source_code_url = coin['urls']['source_code'].nil? ? '' : coin['urls']['source_code'].first

                    ## parse the source code url into a useable format for github
                    parsed_github_repo_url = GithubHelper.parse_github_repo_url(coin_marketcap_source_code_url)
                    github_url = ""
                    if parsed_github_repo_url
                        owner = parsed_github_repo_url[:owner]
                        repo = parsed_github_repo_url[:repo]
                        puts "owner: #{owner}, repo: #{repo}"
                        github_url = GithubHelper.build_github_repo_url(owner, repo)
                    end
                    puts "source_code: #{coin_marketcap_source_code_url}, github_url: #{github_url}"
                    Db::coins
                            .where(coin_marketcap_id: coin_marketcap_id)
                            .update({
                                coin_marketcap_source_code_url: coin_marketcap_source_code_url || "",
                                github_url: github_url || ""
                            })
                end
            end
        end


        # Load github metadata from the file
        def load_github_metadata_from_file
            puts "Loading github data from file..."
            raw_file = Dir['data/github-metadata/parsed/*'].each do |fname|
                github_metadata = JSON.parse(File.read(fname))
                github_url = GithubHelper.build_github_repo_url(github_metadata['owner'], github_metadata['repo'])

                coin = Db::coins.find_by(github_url: github_url)
                github_metadata['coin_id'] = coin.id
                puts "Inserting #{github_metadata}"
                Db::github_metadata.insert(github_metadata)
            end
        end

        # Load all of the github metadata via the api
        #@param [Boolean] reload_data If true, then the data will be reloaded from the api 
        #                             if it does not exist
        #                            If false, then the data will be loaded from the api
        def load_all_github_metadata(reload_data: true)
            puts "Loading all github data..."
            github_urls = Db::coins.pluck(:github_url)
                    .filter{|url| !url.empty?}
            puts "loading #{github_urls.count} github urls"

            github_urls.each do |github_url|
                parsed_url = GithubHelper.parse_github_repo_url(github_url)
                owner = parsed_url[:owner]
                repo = parsed_url[:repo]
                github_url = GithubHelper.build_github_repo_url(owner, repo)
                puts "github_url: #{github_url}"

                # Check if the url already exists... if it does, we don't want to reload it
                # If the reload data is false, however if reload_data is true, then we want to
                # reload the information
                metadata = Db::github_metadata.find_by(source_code_url: github_url)
                if !metadata.nil? && !reload_data
                    puts "The metadata for #{github_url} already exists, skipping..."
                    next
                end
                puts "Updating github data for #{owner}/#{repo}"

                github_metadata = LoadGithubData.new(owner, repo).load_data_from_api
                puts "github_metadata: #{github_metadata}"

                coin = Db::coins.find_by(github_url: github_url)
                github_metadata['coin_id'] = coin.id
                puts "Insert or update #{github_metadata}"

                Db::github_metadata.find_or_initialize_by(
                    {source_code_url: github_url}
                ).update!(github_metadata)
            end
        end

        def load_coin_marketcap_coin_data_from_api
            puts "Loading coin marketcap coin data from API..."
            data = LoadCoinMarketcapData.load_all_cryptocurrencies
            data.each do |coin|
                Db::coins.insert({
                    coin_marketcap_id: coin['id'].to_i,
                    name: coin['name'],
                    symbol: coin['symbol'],
                    slug: coin['slug']})
            end
        end

        def load_coin_marketcap_metadata_from_api
            puts "Loading coin marketcap metadata from API..."
            LoadCoinMarketcapData.load_all_metadata
            load_coin_marketcap_metadata_from_file
        end
    end
end
