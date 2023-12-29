# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#set :output, "/path/to/my/cron_log.log"
#
every 12.hours do
  rake "appointment_reminders:send_reminders"
end

every 1.day, :at => '12:00 am' do
  rake "appointments:actualizar_estado"
end

