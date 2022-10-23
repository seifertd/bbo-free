# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "bbo-free"
set :repo_url, "git@github.com:seifertd/bbo-free.git"
set :user, "doug"
set :group, "doug"
set :use_sudo, false
set :tmp_dir, "/tmp"

# Default branch is :master
set :branch, ENV['BRANCH'] || 'main'

# rvm
set :rvm_ruby_version, "ruby-3.1.1"
set :rvm_type, :system

set :log_level, :debug

set :passenger_restart_with_touch, true

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key', 'config/secrets.yml', 'db/production.sqlite3'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/assets"

# Default value for default_env is {}
set :default_env, { rvm_bin_path: "/usr/local/rvm/bin" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
