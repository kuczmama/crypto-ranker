# This file combines all JSON files under ../parsed into a single CSV file.
# Run this script with `ruby concat2csv.rb`

require 'csv'
require 'json'

CSV.open("combined_data.csv", "w") do |csv|
    dir = Dir["../parsed/*"]

    # Append CSV header using first JSON file
    csv_row = Array.new
    JSON.parse(File.open(dir[0]).read).each do |hash|
        csv_row.push(hash[0])
    end
    csv << csv_row

    # Append JSON values in each file to the csv
    dir.each do |file|
        csv_row = Array.new
        JSON.parse(File.open(file).read).each do |hash|
            csv_row.push(hash[1])
        end
        csv << csv_row
    end
end