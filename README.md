# redis-server

This is a very basic Sinatra server to serve HTML from a redis store. It is taken from:

http://ember-cli-deploy.com/docs/v0.6.x/lightning-strategy-examples/#example-sinatra-app

It includes Universal Links support, providing a /apple-app-site-association file if required.

Steps to get this working:

* Clone this repository to /var/www
* Create a config file in /var/www as below
* Set up a server with nginx and Passenger:

# Config file

This should be called redis_config.yml and be located in /var/www. The format is:

    host: <redis host IP>
    port: <redis port>
    password: <redis password>
    project: <name of your project - the redis key should match this>
    app_id: <app_id for apple universal links, if required>

# Installing nginx and Passenger (assuming an Ubuntu system):

Taken from here: https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/trusty/install_passenger.html

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates
    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update
    sudo apt-get install -y nginx-extras passenger

Update /etc/nginx/nginx.conf - uncomment the line

    include /etc/nginx/passenger.conf;

Delete default file from /etc/nginx/sites-enabled and add server.conf:

    server {
      listen 80;
      # server_name yourserver.com;

      # Tell Nginx and Passenger where your app's 'public' directory is
      root /var/www/redis-server/public;

      # Turn on Passenger
      passenger_enabled on;
      passenger_ruby /usr/bin/ruby;
    }

# Gem requirements

    apt-get install ruby
    gem install sinatra
    gem install redis

# Admin Interface

This script optionally serves a separate admin app at /admin
