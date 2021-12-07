require 'sinatra'
require 'sinatra/base'

BASE = "/api/v1"
get "#{BASE}/projects" do
  [{
    url: "https://github.com/solana-labs/solana",
    language: 'Rust',
    open_issues: 717,
    stars: 5956,
    commits: 16788,
    contributors: 228,
    most_recent_commit: '2021-12-06T23:34:10Z',
    days_since_last_commit: 0
}].to_json
end