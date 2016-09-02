require 'sinatra'
require 'redis'
require 'yaml'

class ServerApp < Sinatra::Base
  get '/' do
    content_type 'text/html'

    settings = YAML.load_file('/var/www/redis_config.yml')
    redis = Redis.new(host: settings["host"], port: settings["port"], password: settings["password"])
    project = settings['project']
    index_key = params[:index_key] || redis.get("#{project}:index:current")
    redis.get("#{project}:index:#{index_key}")
  end
end
