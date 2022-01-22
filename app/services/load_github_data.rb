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
        # puts "json data: #{json_data}"
        language = json_data["language"]
        watchers_count = json_data["watchers_count"]
        open_issues_count = json_data['open_issues_count']
        commit_count = get_total_number_of_commits
        contributors_count = get_total_number_of_contributors
        stars_count = json_data['stargazers_count']
        forks_count = json_data['forks_count']
        most_recent_commit_date = get_date_of_most_recent_commit
        size = json_data['size']
        days_since_last_commit = (Date.today - Date.parse(most_recent_commit_date)).to_i
        return {
            language: language,
            watchers_count: watchers_count,
            open_issues_count: open_issues_count,
            commit_count: commit_count,
            contributors_count: contributors_count,
            stars_count: stars_count,
            forks_count: forks_count,
            most_recent_commit_date: most_recent_commit_date,
            size: size,
            days_since_last_commit: days_since_last_commit,
            owner: @owner,
            repo: @repo
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

    private

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