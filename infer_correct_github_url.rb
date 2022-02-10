# There are some projects that have the same github url but different,
# one is a good project... the other one is bad...
# We need to figure out which one is better...

require_relative '../app/db'


Db::coins
        .select(:github_url)
        .having(Arel.star.count.gt(1))
        .group(:github_url).each do |coin|
    next if coin.github_url.nil? || coin.github_url.empty?

    duplicate_coins = Db::coins.where(github_url: coin.github_url)
    min_coin_marketcap_id = duplicate_coins.pluck(:coin_marketcap_id).min
    # puts duplicate_coins.count
    duplicate_coins.where("coin_marketcap_id > ? ", min_coin_marketcap_id) do |duplicate_coin|
        Db::github_metadata.where(coin_id: duplicate_coin.id).delete
    end
    duplicate_coins.delete_all
end