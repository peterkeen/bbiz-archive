require 'sinatra'
require 'date'
require 'json'
require 'fileutils'

class BootstrapArchiveApp < Sinatra::Base

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['USERNAME'], ENV['PASSWORD']]
    end
  end

  get '/' do
    protected!
    @dirs = get_dirs
    p @dirs
    erb :index
  end

  get %r{/([a-z0-9_-]+/\d+/\d+/\d+)} do
    protected!
    @path = params[:captures].first
    @posts = get_posts(@path)
    erb :posts
  end
  
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

  def get_dirs
    Dir.chdir(ENV['ARCHIVE_DIR']) do
      Dir.glob('*/*/*/*').sort
    end
  end

  def get_posts(path)
    glob = File.join(ENV['ARCHIVE_DIR'], path, '*.json')
    posts = []
    Dir.glob(glob).sort.map do |filename|
      File.open(filename, 'r:utf-8') do |f|
        posts << JSON.parse(f.read)
      end
    end
    posts
  end
end
