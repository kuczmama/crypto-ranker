require 'json'
Dir.glob(File.join('data', 'github-metadata', 'raw', '*.json')) do |file_path|
    data = JSON.parse(File.read(file_path))
    if !data["message"].nil?
        file_name = File.basename(file_path)
        # File.delete(file_path)
        parsed_filename = "#{file_name.split('.')[0]}-metadata.json"
        parsed_filepath = File.join('data', 'github-metadata', 'parsed', parsed_filename)
        if File.exists?(parsed_filepath)
            File.delete(parsed_filepath)
            puts "Parse filepath exists.. #{parsed_filepath}" 
        else
            puts "Parse filepath does not exist.. #{parsed_filepath}"
        end
        File.delete(file_path)
        # puts "deleteting #{file_name}"
    end
end