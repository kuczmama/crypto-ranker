# Load github data

require 'net/http'
require 'json'
require 'date'

class LoadGithubData
    def initialize(owner, repo)
        @repo = repo.downcase
        @owner = owner.downcase
        @base_url = "https://api.github.com/repos/#{@owner}/#{@repo}"
        @username = ENV['GITHUB_USERNAME']
        @token = ENV['GITHUB_TOKEN']
    end

    def write_data_to_file(fname, data)
        return "skipping #{fname} as there is no data to write" if data.nil?
        file_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..","data", "github-metadata", fname))
        puts "Writing data to #{file_path}"
        File.open(file_path, 'w') do |f|
            f.write(JSON.pretty_generate(data))
        end
    end

    # This loads all of the data from the github api
    # It also writes that data to a file so it can be read from
    def load_data_from_api
        json_data = load_json(@base_url)
        language = json_data["language"] || ""
        watchers_count = json_data["watchers_count"] || 0
        open_issues_count = json_data['open_issues_count'] || 0
        commit_count = get_total_number_of_commits || 0
        contributors_count = get_total_number_of_contributors || 0
        stars_count = json_data['stargazers_count'] || 0
        forks_count = json_data['forks_count'] || 0
        most_recent_commit_date = get_date_of_most_recent_commit || Date.new
        source_code_url = GithubHelper.build_github_repo_url(@owner, @repo)
        size = json_data['size'] || 0
        days_since_last_commit = (Date.today - Date.parse(most_recent_commit_date)).to_i
        write_data_to_file("raw/#{@owner}_#{@repo}.json", json_data)
        result = {
            language: language,
            watchers_count: watchers_count,
            open_issues_count: open_issues_count,
            commit_count: commit_count,
            contributors_count: contributors_count,
            stars_count: stars_count,
            forks_count: forks_count,
            size: size,
            days_since_last_commit: days_since_last_commit,
            source_code_url: source_code_url,
            owner: @owner,
            repo: @repo
        }
        write_data_to_file("parsed/#{@owner}_#{@repo}_metadata.json", result)
        return result
    end

    private

    def get_date_of_most_recent_commit
        json_data = load_json("#{@base_url}/commits?per_page=1")
        date = Date.new.to_s
        return date if json_data.nil?
        return date if json_data[0].nil?
        return date if json_data[0]['commit'].nil?
        return date if json_data[0]['commit']['author'].nil?
        json_data[0]["commit"]["author"]["date"]
    end

    ## Get total number of github commits
    def get_total_number_of_commits
        res = request("#{@base_url}/commits?per_page=1")
        return 0 if res.nil?
        return 0 if res.to_hash['link'].nil?
        link = res.to_hash['link'][-1]
        matches = /page=([0-9]+)>\;\srel="last"/.match(link)
        if matches
            return matches[1].to_i
        else
            return 0
        end
    end

    def get_total_number_of_contributors
        res = request("#{@base_url}/contributors?per_page=1")
        return 0 if res.nil?
        return 0 if res.to_hash['link'].nil?
        link = res.to_hash['link'][-1]
        matches = /page=([0-9]+)>\;\srel="last"/.match(link)
        if matches
            return matches[1].to_i
        else
            return 0
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

# puts LoadGithubData.new('paritytech', 'polkadot').load_data_from_api
# LoadGithubData.new('bitcoin', 'bitcoin').load_data_from_api
# puts LoadGithubData.new('solana-labs', 'solana').load_data_from_api
# puts LoadGithubData.new('dogecoin', 'dogecoin').load_data_from_api
# puts LoadGithubData.new('Zebec-protocol', 'zebec-sdk').load_data_from_api