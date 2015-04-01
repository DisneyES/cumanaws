# Debian GNU/Linux:

1. **Install bundler and other dependences:**

        # apt-get install bundler libpq-dev nodejs mongodb

2. **Configure user to install gems locally:**
    
        $ mkdir $HOME/.bundle`
        $ echo "---" > $HOME/.bundle/config
        $ echo "BUNDLE_PATH: vendor/bundle" >> $HOME/.bundle/config

3. **Install gems:**

        $ cd <cumanaws's directory>
        $ bundle install