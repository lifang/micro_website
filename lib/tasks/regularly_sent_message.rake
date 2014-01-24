#encoding: utf-8
namespace :sms_alert do
  desc "Statistics amount each month to complete"
  task(:regularly_sent_message => :environment) do
    Message::send_message
  end
end