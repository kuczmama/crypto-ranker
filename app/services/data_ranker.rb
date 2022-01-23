require_relative '../db'

class DataRanker
    class << self
        def calculate_rank_score(github_metadata)
            # Rank amongst all the other repos in numbers
            watchers_count_rank = Db::github_metadata.pluck(:watchers_count).uniq.sort.reverse.index(github_metadata.watchers_count)
            open_issues_count_rank = Db::github_metadata.pluck(:open_issues_count).uniq.sort.reverse.index(github_metadata.open_issues_count)
            commit_count_rank = Db::github_metadata.pluck(:commit_count).uniq.sort.reverse.index(github_metadata.commit_count)
            stars_count_rank = Db::github_metadata.pluck(:stars_count).uniq.sort.reverse.index(github_metadata.stars_count)
            forks_count_rank = Db::github_metadata.pluck(:forks_count).uniq.sort.reverse.index(github_metadata.forks_count)
            size_count_rank = Db::github_metadata.pluck(:size).uniq.sort.reverse.index(github_metadata.size)
            days_since_last_commit_rank = Db::github_metadata.pluck(:days_since_last_commit).uniq.sort.index(github_metadata.days_since_last_commit)

            # Calculate the rank of each of the numbers above.. lower is better
            rank = watchers_count_rank + open_issues_count_rank + stars_count_rank + forks_count_rank + size_count_rank + days_since_last_commit_rank
            puts "Rank: #{rank}"
            coin = Db::coins.find_by(id: github_metadata.coin_id)
            puts "slug: #{coin.slug}"
            coin.update!(rank: rank)
            rank
        end

        def calculate_ranks
            scores = Db::coins.pluck(:rank_score).sort
            Db::coins.all.each do |coin|
                coin.update!(rank: scores.index(coin.rank_score))
                puts "Updating #{coin.slug} to rank: #{coin.rank}"
            end
        end
    end
end

DataRanker.calculate_ranks
# Db::github_metadata.all.each do |github_metadata|
#     DataRanker.calculate_rank_score(github_metadata)
# end