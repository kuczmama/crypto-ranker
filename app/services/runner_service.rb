require 'time'
require_relative '../../db'

# This is a helper class that can run an arbitrary function
# Every x minutes, it will run the function
class RunnerService
    class << self
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
            # Get the last time the function was run
            num_minutes_elapsed = minutes_elapsed(function_name)
            if num_minutes_elapsed >= time_interval
                puts "It has been #{num_minutes_elapsed} minutes since the last time '#{function_name}' was run."
                # Run the function
                thread = Thread.new(&function)
                thread.join
                # Write the last run time to the database
                Db::runner_logs.find_or_initialize_by(
                    {function_name: function_name}
                ).update!({last_run_time: Time.now})
            else
                puts "Function was not run, only #{num_minutes_elapsed} minutes have elapsed"
                # Do nothing
            end
        end

        private

        # Get the number of minutes since the function
        # was last run. 
        #
        # @param [String] function_name
        # @return [Integer] The number of minutes
        # since the function was last run. If the 
        # function was never ran, then return infinity.
        def minutes_elapsed(function_name)
            runner_logs = Db::runner_logs.find_by(function_name: function_name)
            # Check if file exists
            if runner_logs.nil?
                #Return infinity
                return Float::INFINITY
            end
            
            # Get the last time the function was run
            (Time.now - runner_logs.last_run_time).to_i / 60
        end
    end
end
