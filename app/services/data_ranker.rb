require_relative '../db'

class DataRanker
    class << self
        def calculate_rank(github_metadata)
            # Rank amongst all the other repos in numbers
            watchers_count_rank = Db::github_metadata.pluck(:watchers_count).uniq.sort.reverse.index(github_metadata.watchers_count)
            open_issues_count_rank = Db::github_metadata.pluck(:open_issues_count).uniq.sort.reverse.index(github_metadata.open_issues_count)
            commit_count_rank = Db::github_metadata.pluck(:commit_count).uniq.sort.reverse.index(github_metadata.commit_count)
            stars_count_rank = Db::github_metadata.pluck(:stars_count).uniq.sort.reverse.index(github_metadata.stars_count)
            forks_count_rank = Db::github_metadata.pluck(:forks_count).uniq.sort.reverse.index(github_metadata.forks_count)
            size_count_rank = Db::github_metadata.pluck(:size).uniq.sort.reverse.index(github_metadata.size)
            days_since_last_commit_rank = Db::github_metadata.pluck(:days_since_last_commit).uniq.sort.index(github_metadata.days_since_last_commit)
            # t.string :language, null: false, default: ""
            # t.integer :watchers_count, null: false, default: 0
            # t.integer :open_issues_count, null: false, default: 0
            # t.integer :commit_count, null: false, default: 0
            # t.integer :contributors_count, null: false , default: 0
            # t.integer :stars_count, null: false, default: 0
            # t.integer :forks_count, null: false, default: 0
            # t.integer :size, null: false, default: 0
            # t.integer :days_since_last_commit, null: false, default: 0

            # puts "watchers_count_rank: #{watchers_count_rank}"
            # puts "forks count rank: #{forks_count_rank}"
            # puts "open issues count rank: #{open_issues_count_rank}"
            # puts "commit count rank: #{commit_count_rank}"
            # puts "stars count rank: #{stars_count_rank}"
            # puts "size count rank: #{size_count_rank}"
            # puts "days since last commit rank: #{days_since_last_commit_rank}"

            # Calculate the rank of each of the numbers above.. lower is better
            rank = watchers_count_rank + open_issues_count_rank + stars_count_rank + forks_count_rank + size_count_rank + days_since_last_commit_rank
            puts "Rank: #{rank}"
            coin = Db::coins.find_by(id: github_metadata.coin_id)
            puts "slug: #{coin.slug}"
            coin.update!(rank: rank)
            rank
        end
    end
end

github_metadata = Db::github_metadata.all.each do |github_metadata|
    DataRanker.calculate_rank(github_metadata)
end