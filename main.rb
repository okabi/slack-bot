# coding: utf-8
require 'slack'
require_relative './define.rb'


def log(log_path, text)
  now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  `echo "#{now} - #{text}" >> #{log_path}`
end


log_path = Time.now.strftime("%Y%m%d%H%M%S") + '.log'
begin
  # Initialize
  client = (Slack::Client.new token: Define::BotToken).realtime
  Slack.configure do |config|
    config.token = Define::WebToken
  end

  # Set KUSO program
  client.on :message do |data|
    next if data.key?('bot_id')
    next if data['channel'] != Define::ChinkoChannelID
    params = {
      token: Define::WebToken,
      channel: Define::ChinkoChannelID,
      username: 'コンちゃん',
      icon_url: Define::BotIconURL,
      text: data['text'].split('').shuffle.join,
    }
    Slack.chat_postMessage params
  end

  client.on :hello do
    puts 'Successfully connected.'
    log log_path, "Start"
  end

  # Run KUSO program
  client.start
rescue => e
  log log_path, "Error: #{e.message}"
  retry
end
