# There are some projects that have the same github url but different,
# one is a good project... the other one is bad...
# We need to figure out which one is better...

require_relative '../db'

# Select coins with a duplicate github url
Db::coins
        .select(:github_url)
        .having(Arel.star.count.gt(1))
        .group(:github_url).each do |coin|
    next if coin.github_url.nil? || coin.github_url.empty?
    
    duplicate_coins = Db::coins.where(github_url: coin.github_url)
    min_coin_marketcap_id = duplicate_coins.pluck(:coin_marketcap_id).min
    puts "min_coin_marketcap_id: #{min_coin_marketcap_id}"
    # puts duplicate_coins.count
    duplicate_coins.where("coin_marketcap_id > ? ", min_coin_marketcap_id).each do |duplicate_coin|
        # puts duplicate_coin.inspect
        puts "Deleting #{duplicate_coin.inspect}..."
        Db::github_metadata.where(coin_id: duplicate_coin.id).delete_all
        duplicate_coin.delete
    end
end