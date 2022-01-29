require_relative '../db'

class DataRanker
    class << self
        def calculate_rank_score(github_metadata)
            # Rank amongst all the other repos in percentages

            watchers_count_rank = github_metadata.watchers_count.to_f / Db::github_metadata.pluck(:watchers_count).max

            ## Open issues count rank
            open_issues_count_rank = github_metadata.open_issues_count.to_f / Db::github_metadata.pluck(:open_issues_count).max

            commit_count_rank = github_metadata.commit_count.to_f / Db::github_metadata.pluck(:commit_count).max * 0.5

            ## Contributors count, multiplied by 2.0 to make it more important
            contributors_count_rank = github_metadata.contributors_count.to_f / Db::github_metadata.pluck(:contributors_count).max * 2.0

            stars_count_rank = github_metadata.stars_count.to_f / Db::github_metadata.pluck(:stars_count).max

            # Size is only worth 10% of whateverything else is worth because it's not a great measurement
            # size_count_rank = (github_metadata.size.to_f / Db::github_metadata.pluck(:size).max) * 0.1
            forks_count_rank = github_metadata.forks_count.to_f / Db::github_metadata.pluck(:forks_count).max

            # Calculate the number of days since last commit, this isn't a great measurement so it's only worth half
            days_since_last_commit = github_metadata.days_since_last_commit.to_f
            days_since_last_commit_rank = (days_since_last_commit <= 0 ? 1 : (1 / days_since_last_commit)) * 0.5
            # puts "watchers_count_rank: #{watchers_count_rank}\nopen_issues_count_rank: #{open_issues_count_rank}\ncommit_count_rank: #{commit_count_rank}\nstars_count_rank: #{stars_count_rank}\nsize_count_rank: #{size_count_rank}\ndays_since_last_commit_rank: #{days_since_last_commit_rank}"

            # Calculate the rank of each of the numbers above.. lower is better
            rank = (
                    watchers_count_rank + open_issues_count_rank + 
                    commit_count_rank +  stars_count_rank + forks_count_rank + days_since_last_commit_rank)
            puts "Rank: #{rank}"
            coin = Db::coins.find_by(id: github_metadata.coin_id)
            coin.update!(rank_score: rank)
        end

        def calculate_ranks
            scores = Db::coins.pluck(:rank_score).sort.reverse
            Db::coins.all.each do |coin|
                coin.update!(rank: scores.index(coin.rank_score) + 1)
                puts "Updating #{coin.slug} to rank: #{coin.rank}"
            end
        end
    end
end

count = Db::github_metadata.count
Db::github_metadata.all.each_with_index do |github_metadata, idx|
    puts "#{idx}/#{count}"
    DataRanker.calculate_rank_score(github_metadata)
end
DataRanker.calculate_ranks
