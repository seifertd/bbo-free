set :application, "bbo-free"
set :repo_url, "git@github.com:seifertd/bbo-free.git"
set :user, "doug"
set :group, "doug"
set :use_sudo, false
set :tmp_dir, "/tmp"

# Default branch is :master
set :branch, ENV["BRANCH"] || "main"

# rvm — derive the ruby@gemset from .ruby-version + .ruby-gemset so there is a
# single source of truth shared with local dev.
set :rvm_ruby_version, "ruby-#{File.read('.ruby-version').strip}@#{File.read('.ruby-gemset').strip}"
set :rvm_type, :system

# capistrano-rvm only routes commands through an existing ruby@gemset; it does
# not create the gemset. Ensure it exists (idempotent).
namespace :rvm do
  desc "Create the RVM gemset if it does not yet exist"
  task :create_gemset do
    on roles(fetch(:rvm_roles, :all)) do
      version, gemset = fetch(:rvm_ruby_version).sub(/\Aruby-/, "").split("@")
      next unless gemset
      rvm = "#{fetch(:rvm_path)}/bin/rvm"
      execute rvm, version, "do", rvm, "gemset", "create", gemset
    end
  end
end

# Must run after rvm:hook (which sets :rvm_path) but before rvm:check, which on a
# debug log_level runs `ruby --version` through the ruby@gemset and would fail if
# the gemset is missing. Both rvm:hook and rvm:check fire right after the stage
# loads, long before bundler:install — so hooking there is too late.
after "rvm:hook", "rvm:create_gemset"

set :log_level, :debug

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
append :linked_files, "config/database.yml", "config/master.key", "config/credentials.yml.enc", "db/production.sqlite3"

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
