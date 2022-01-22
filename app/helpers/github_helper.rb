require 'uri'

class GithubHelper
    class << self
        # Parses a given string if it is a valid githuburl
        # for example the host is "github.com" and the path "/<owner>/<repo>"
        # 
        # @param url [String] - The url to parse
        # @return {owner: string, repo: string}
        # false if the url is not a valid github repo url
        #
        # @example
        # https://github.com/Crypto-Expert/HoboNickels
        # => {owner: "Crypto-Expert", repo: "HoboNickels"}
        #
        # This is a valid github repo url, because it has the host "github.com"
        # and the path "/<owner>/<repo>", where owner is "Crypto-Expert" and repo is "HoboNickels"
        # 
        # @example
        # https://github.com/safex/
        # => false
        #
        # https://github.com/safex/  is not a valid github repo url, 
        # even though it has the host "github.com" because 'safex' is 
        # only the owner of the repo, not the repo name
        # 
        def parse_github_repo_url(str)
            return false if str.nil?
            begin
                uri = URI.parse(str)
                return false if uri.nil?
                return false if !uri.kind_of?(URI::HTTP)
                return false if uri.host != 'github.com'
                path = uri.path
                return false if path.nil?
                return false if path.empty?

                # We want to make sure that the path is in the format "/<owner>/<repo>"
                split_path = path.split('/').filter{|x| !x.nil? && x.kind_of?(String) && !x.empty?}
                return false if split_path.length != 2
                return {owner: split_path[0], repo: split_path[1]}
            rescue
                return false
            end
        end
    end
end

# def test(expected, actual)
#     if expected == actual
#         puts "."
#     else
#         puts "Got #{actual} instead of #{expected}"
#     end
# end

# test(false, GithubHelper.parse_github_repo_url('x'))
# test(false, GithubHelper.parse_github_repo_url('https://x'))
# test(false, GithubHelper.parse_github_repo_url(2))
# test(false, GithubHelper.parse_github_repo_url('https://github.com/x'))
# test(false, GithubHelper.parse_github_repo_url('https://bitbucket.com/Crypto-Expert/HoboNickels'))
# test(false, GithubHelper.parse_github_repo_url('https://bitbucket.com/Crypto-Expert/HoboNickels?x=y'))
# result = GithubHelper.parse_github_repo_url('https://github.com/Crypto-Expert/HoboNickels')
# test(result[:owner], 'Crypto-Expert')
# test(result[:repo], 'HoboNickels')
# result = GithubHelper.parse_github_repo_url('https://github.com/bitcoin/bitcoin?x=1&y=2')
# test(result[:owner], 'bitcoin')
# test(result[:repo], 'bitcoin')
