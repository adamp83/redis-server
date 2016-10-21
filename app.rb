require 'sinatra'
require 'redis'
require 'yaml'

class ServerApp < Sinatra::Base

  settings = YAML.load_file('/var/www/redis_config.yml')
  redis = Redis.new(host: settings["host"], port: settings["port"], password: settings["password"])
  project = settings['project']

  # Serve the main website at /
  get '/' do
    content_type 'text/html'
    index_key = params[:index_key] || redis.get("#{project}:index:current")
    redis.get("#{project}:index:#{index_key}")
  end

  # Serve revisions
  get '/revisions/:index_key' do
    content_type 'text/html'
    index_key = params[:index_key] || redis.get("#{project}:index:current")
    redis.get("#{project}:index:#{index_key}")
  end

  # Serve a separate admin website at /admin
  get '/admin' do
    content_type 'text/html'
    index_key = params[:index_key] || redis.get("#{admin_project}:index:current")
    redis.get("#{settings['admin_project']}:index:#{index_key}")
  end

  # Create a apple-app-site-association JSON file
  get '/apple-app-site-association' do
    content_type 'application/json'
    text=<<-ENDTEXT
    {
      "applinks": {
          "apps": [],
          "details": [
              {
                  "appID": "#{settings['app_id']}",
                  "paths": [ "*" ]
              }
          ]
      }
    }
    ENDTEXT
    text
  end
end
