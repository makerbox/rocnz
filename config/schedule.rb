# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 10.minutes do
  # PopulateJob.perform_async()
  Contact.create(code:'running', email:'running')
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#MOVED FROM WHENEVER TO TASK SCHEDULER, because Windows doesn't have crontab