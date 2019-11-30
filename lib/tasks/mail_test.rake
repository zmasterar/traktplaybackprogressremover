task :mail_test => :environment do
    CalendarMailer.test.deliver_now
end