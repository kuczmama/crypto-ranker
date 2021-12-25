require 'time'

class DataProcessingService
    class << self
        LOG_DIR = "#{Dir.home}/data_processing_logs"

        # This method processes an arbitrary function
        # every t minutes.
        #
        # This is designed to be called from a cron job. The
        # cron job should be configured to run every 1 minute.
        # This method will run the arbitrary function 
        # every t minutes.  
        #
        # It will do so by writing, the last time the function
        # was run to a file, and only if the time elapsed is greater
        # than or equal to t, will the function be run.
        #
        # @param [String] function_name
        # @param [Integer] t - interval in minutes to run the function
        # @param [Block] function
        def process(function_name, time_interval, &function)
            # Check if the log path exists, if not create it
            log_file = nil
            if File.directory?(LOG_DIR)
                log_file = File.join(LOG_DIR, "#{function_name}.log")
            else
                Dir.mkdir(LOG_DIR)
                log_file = File.join(LOG_DIR, "#{function_name}.log")
            end

            # Get the last time the function was run
            num_minutes_elapsed = minutes_elapsed(log_file)
            if num_minutes_elapsed >= time_interval
                puts "It has been #{num_minutes_elapsed} minutes since the last time '#{function_name}' was run."
                # Run the function
                thread = Thread.new(&function)
                thread.join
                # Write the time to the file
                File.open(log_file, "a") do |file|
                    file.write("#{Time.now.to_s}\n")
                end
            else
                puts "Function was not run, only #{num_minutes_elapsed} minutes have elapsed"
                # Do nothing
            end
        end

        private

        # Get the number of minutes since the function
        # was last run. 
        #
        # @param [String] file_name
        # @return [Integer] The number of minutes
        # since the function was last run. If the 
        # function was never ran, then return infinity.
        def minutes_elapsed(file_path)
            # Check if file exists
            unless File.exist?(file_path)
                #Return infinity
                return Float::INFINITY
            end
            # Get the last time the function was run
            # from the file
            
            # Get the last time the function was run
            last_time = IO.readlines(file_path).last(1).first
            ## Convert to minutes elapsed and return
            (Time.now - Time.parse(last_time)).to_i / 60
        end
    end
end

DataProcessingService.process("hello", 1) do
    puts "Hello"
end

DataProcessingService.process("yo", 1) do
    puts "yo"
end