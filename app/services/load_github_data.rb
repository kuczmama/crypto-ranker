# Load github data

require 'net/http'
require 'json'
require 'date'

class LoadGithubData
    def initialize(owner, repo)
        @repo = repo
        @owner = owner
        @base_url = "https://api.github.com/repos/#{@owner}/#{@repo}"
        @username = ENV['GITHUB_USERNAME']
        @token = ENV['GITHUB_TOKEN']
    end

    def load_data
        json_data = load_json(@base_url)
        most_recent_commit_date = get_date_of_most_recent_commit
        puts %Q{
            Url: https://github.com/#{@owner}/#{@repo}
            Language: #{json_data['language']}
            Number of open issues: #{json_data['open_issues_count']}
            Stars: #{json_data['stargazers_count']}
            Num Commits: #{get_total_number_of_commits}
            Contributors: #{get_total_number_of_contributors}
            Most recent commit: #{most_recent_commit_date}
            Days since last commit: #{(Date.today - Date.parse(most_recent_commit_date)).to_i}
        }
    end

    private

    def get_date_of_most_recent_commit
        json_data = load_json("#{@base_url}/commits?per_page=1")
        json_data[0]["commit"]["author"]["date"]
    end

    ## Get total number of github commits
    def get_total_number_of_commits
        res = request("#{@base_url}/commits?per_page=1")
        link = res.to_hash['link'][-1]
        matches = /page=([0-9]+)>\;\srel="last"/.match(link)
        if matches
        return matches[1].to_i
        else
        return "N/A"
        end
    end

    def get_total_number_of_contributors
        res = request("#{@base_url}/contributors?per_page=1")
        link = res.to_hash['link'][-1]
        matches = /page=([0-9]+)>\;\srel="last"/.match(link)
        if matches
            return matches[1].to_i
        else
            return "N/A"
        end
    end

    def request(url)
        uri = URI.parse(url)
        request = Net::HTTP::Get.new(uri)
        request.basic_auth(@username, @token)

        req_options = {use_ssl: uri.scheme == "https"}

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
        response
    end

    # Load data from github via url
    def load_json(url)
        response = request(url).body
        JSON.parse(response)
    end
end

puts LoadGithubData.new('paritytech', 'polkadot').load_data
puts LoadGithubData.new('bitcoin', 'bitcoin').load_data
puts LoadGithubData.new('solana-labs', 'solana').load_data
puts LoadGithubData.new('dogecoin', 'dogecoin').load_data
puts LoadGithubData.new('Zebec-protocol', 'zebec-sdk').load_data