require_relative 'app/db'

Db::github_metadata.select(:source_code_url).uniq.each do |github_metadata|
    source_code_url = github_metadata[:source_code_url]
    last_date = Db::github_metadata
            .where(source_code_url: source_code_url)
            .pluck(:updated_at)
            .sort
            .last
    puts last_date
    puts Db::github_metadata
            .where("updated_at < ? AND source_code_url = ? ", 
                    last_date, 
                    source_code_url).delete_all
end