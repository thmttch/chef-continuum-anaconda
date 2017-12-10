log_level               :info
log_location            STDOUT

# apparently, this should be the username used to log into https://supermarket.chef.io
# https://blog.chef.io/2015/03/16/using-chef-supermarket-a-guided-tour/
node_name               'thmttch'
# this might not work with a relative path, and obviously is not checked in!
client_key              'script/release-key.pem'
