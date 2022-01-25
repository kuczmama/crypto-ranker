# This is the main class for the server
require 'sinatra'
require 'sinatra/base'
require 'active_record'
require 'yaml'
require 'set'
require_relative 'db'

# The max number of results that can be returned from the API in one query
RESPONSE_LIMIT = 100
COIN_COLUMNS = Db::coins.column_names.to_set

def parse_limit
  limit = params[:limit]
  limit = RESPONSE_LIMIT if limit.nil?
  limit = limit.to_i > RESPONSE_LIMIT ? RESPONSE_LIMIT : limit.to_i
  limit = limit < 0 ? RESPONSE_LIMIT : limit
end

def parse_order
  sort = params[:sort]
  order = :asc
  sort = 'rank' if sort.nil?
  order = :desc if sort[0] == '-'
  sort = sort[1..-1] if (sort[0] == '-' || sort[0] == '+')
  sort = COIN_COLUMNS.include?(sort) ? sort : 'rank'
  result = {}
  result[sort.to_sym] = order
  result
end

def parse_offset(limit)
  page = params[:page]
  page = 0 if page.nil?
  page = page.to_i
  page = page < 1 ? 0 : page

  offset = page * limit
  offset
end

BASE = "/api/v1"
get "#{BASE}/coins" do
  limit = parse_limit
  offset = parse_offset(limit)
  Db::coins.order(parse_order).offset(offset).limit(limit).all.to_json || [].to_json
end

get "#{BASE}/coins/:slug" do
  result = Db::coins.find_by(slug: params[:slug])
  result.nil? ? [].to_json : result.to_json
end

not_found do
  status 404
  { error: "Not found" }.to_json
end

error 400..510 do
  {message: "Something went wrong"}.to_json
end