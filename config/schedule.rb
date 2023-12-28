# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/path/to/my/cron_log.log"
#
every 2.minutes do
  require './app/mailers/user_mailer.rb'

  Appointment.all.each do |a|
    if a.start_time == Date.tomorrow
      UserMailer.appointment_reminder(a)
    end
  end
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
