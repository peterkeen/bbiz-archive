require 'sinatra'
require 'date'
require 'json'
require 'fileutils'

class BootstrapArchiveApp < Sinatra::Base
  post '/_archive' do
    return 'nok' unless params[:token] == ENV['SLACK_TOKEN']
    timestamp = params[:timestamp]
    channel = params[:channel_name]
    date = Date.today.strftime('%Y/%m/%d')
    filename = File.expand_path(File.join(ENV['ARCHIVE_DIR'], channel, date, timestamp + '.' + params[:user_id] + '.json'), __FILE__)
    puts "writing to filename #{filename}"
    FileUtils.mkdir_p(File.dirname(filename))

    File.open(filename, 'w+') do |f|
      f.write({
        timestamp: timestamp,
        channel_id: params[:channel_id],
        channel_name: channel,
        user_id: params[:user_id],
        user_name: params[:user_name],
        text: params[:text],
        trigger_word: params[:trigger_word],
      }.to_json)
    end
    'ok'
  end
end
