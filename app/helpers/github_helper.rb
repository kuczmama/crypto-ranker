require 'uri'

class GithubHelper
    class << self

        # Checks if a given string is a github url
        # @param url [String] - The url to check
        #
        # @return [Boolean] - True if the url is a github url
        # False otherwise
        def is_github_url?(str)
            return false if str.nil?
            begin
                uri = URI.parse(str)
                return false if uri.nil?
                return false if !uri.kind_of?(URI::HTTP)
                return uri.host == 'github.com'
            rescue URI::InvalidURIError
                return false
            end
        end
    end
end