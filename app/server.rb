require 'sinatra'
require 'sinatra/base'
require 'active_record'
require 'yaml'
require_relative 'db'


BASE = "/api/v1"
get "#{BASE}/coins" do
  Db::coins.all.to_json
  # [{
  #   url: "https://github.com/solana-labs/solana",
  #   language: 'Rust',
  #   open_issues: 717,
  #   stars: 5956,
  #   commits: 16788,
  #   contributors: 228,
  #   most_recent_commit: '2021-12-06T23:34:10Z',
  #   days_since_last_commit: 0
# }].to_json
end